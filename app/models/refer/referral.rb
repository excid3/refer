module Refer
  class Referral < ApplicationRecord
    belongs_to :referrer, polymorphic: true
    belongs_to :referee, polymorphic: true
    belongs_to :referral_code, optional: true, counter_cache: true

    scope :completed, -> { where.not(completed_at: nil) }

    before_validation do
      self.referrer = referral_code&.referrer
    end

    validate :blocks_self_referral

    def blocks_self_referral
      if referrer == referee
        errors.add(:referee_id, "You can't refer yourself")
      end
    end

    def complete!(**attributes)
      return if completed_at?

      update attributes.with_defaults(completed_at: Time.current)
      Refer.referral_completed&.call(self)
    end
  end
end
