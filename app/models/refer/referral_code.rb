module Refer
  class ReferralCode < ApplicationRecord
    belongs_to :referrer, polymorphic: true
    has_many :referrals, dependent: :nullify
    has_many :visits, dependent: :delete_all

    validates :code, presence: true, uniqueness: true

    before_validation if: -> { !code? && Refer.code_generator } do
      self.code = Refer.code_generator.call(referrer)
    end

    def to_param
      code
    end

    def track_visit(request)
      visits.from_request(request).save
    end
  end
end

ActiveSupport.run_load_hooks :refer_referral_code, Refer::ReferralCode
