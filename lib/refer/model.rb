module Refer
  module Model
    extend ActiveSupport::Concern

    included do
      has_many :referral_codes, as: :referrer, class_name: "Refer::ReferralCode", dependent: :destroy
      has_many :referrals, as: :referrer, class_name: "Refer::Referral", dependent: :destroy
      has_one :referral, as: :referee, class_name: "Refer::Referral", dependent: :destroy
      delegate :referrer, to: :referral, allow_nil: true
    end
  end
end
