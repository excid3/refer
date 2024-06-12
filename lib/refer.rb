require "refer/version"
require "refer/engine"
require "securerandom"

module Refer
  include ActiveSupport::Configurable

  config_accessor :code_generator, default: ->(referrer) { SecureRandom.alphanumeric(8) }
  config_accessor :cookie_length, default: 30.days
  config_accessor :cookie_name, default: :refer_code
  config_accessor :param_name, default: :ref

  class Error < StandardError; end
  class AlreadyReferred < Error; end

  def self.referred?(referee)
    Referral.where(referee: referee).exists?
  end

  def self.refer(code:, referee:)
    return if referred?(referee)
    ReferralCode.find_by(code: code)&.referrals&.create(referee: referee)
  end

  def self.refer!(code:, referee:)
    raise AlreadyReferred, "#{referee} has already been referred" if referred?(referee)
    ReferralCode.find_by!(code: code).referrals.create!(referee: referee)
  end

  def self.cookie(code)
    {
      value: code,
      expires: Refer.cookie_length.from_now
    }
  end
end

ActiveSupport.on_load(:active_record) do
  include Refer::HasReferrals
end

ActiveSupport.on_load(:action_controller) do
  include Refer::Controller
end

ActiveSupport.run_load_hooks(:refer, Refer)
