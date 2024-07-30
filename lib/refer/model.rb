module Refer
  module Model
    extend ActiveSupport::Concern

    included do
      has_many :referral_codes, inverse_of: :referrer, class_name: "Refer::ReferralCode", dependent: :destroy
      has_many :referrals, inverse_of: :referrer, class_name: "Refer::Referral", dependent: :destroy
      has_one :referral, inverse_of: :referee, class_name: "Refer::Referral", dependent: :destroy
      delegate :referrer, to: :referral
    end
  end
end
