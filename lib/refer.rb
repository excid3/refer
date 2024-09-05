require "refer/version"
require "refer/engine"
require "securerandom"

module Refer
  include ActiveSupport::Configurable

  autoload :Controller, "refer/controller"
  autoload :HasReferrals, "refer/has_referrals"
  autoload :Model, "refer/model"

  config_accessor :code_generator, default: ->(referrer) { SecureRandom.alphanumeric(8) }
  config_accessor :cookie_length, default: 30.days
  config_accessor :cookie_name, default: :refer_code
  config_accessor :param_name, default: :ref
  config_accessor :overwrite_cookie, default: true
  config_accessor :track_visits, default: true
  config_accessor :mask_ips, default: true
  config_accessor :referral_completed

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

  # From Ahoy gem: https://github.com/ankane/ahoy/blob/v5.1.0/lib/ahoy.rb#L133-L142
  def self.mask_ip(ip)
    return ip unless mask_ips

    addr = IPAddr.new(ip)
    if addr.ipv4?
      # set last octet to 0
      addr.mask(24).to_s
    else
      # set last 80 bits to zeros
      addr.mask(48).to_s
    end
  end
end

ActiveSupport.run_load_hooks(:refer, Refer)
