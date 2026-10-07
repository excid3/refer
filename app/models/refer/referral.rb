module Refer
  class Referral < ApplicationRecord
    belongs_to :referrer, polymorphic: true, default: -> { referral_code&.referrer }
    belongs_to :referee, polymorphic: true
    belongs_to :referral_code, optional: true, counter_cache: true

    scope :completed, -> { where.not(completed_at: nil) }

    validate :ensure_not_self_referral

    after_update_commit -> { Refer.referral_completed&.call(self) }, if: -> { saved_change_to_completed_at? && completed_at? }

    def ensure_not_self_referral
      errors.add(:base, "Self-referrals are not allowed") if referrer == referee
    end

    def complete!(**attributes)
      update(attributes.with_defaults(completed_at: Time.current)) unless completed_at?
    end
  end
end

ActiveSupport.run_load_hooks :refer_referral, Refer::Referral
