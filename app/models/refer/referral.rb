module Refer
  class Referral < ApplicationRecord
    belongs_to :referrer, polymorphic: true
    belongs_to :referee, polymorphic: true
    belongs_to :referral_code, optional: true, counter_cache: true

    scope :completed, -> { where.not(completed_at: nil) }

    before_validation do
      self.referrer = referral_code&.referrer
    end

    validate :ensure_not_self_referral

    def ensure_not_self_referral
      errors.add(:base, "Self-referrals are not allowed") if referrer == referee
    end

    def complete!(**attributes)
      return if completed_at?

      update attributes.with_defaults(completed_at: Time.current)
      Refer.referral_completed&.call(self)
    end
  end
end
