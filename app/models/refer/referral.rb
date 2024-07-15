module Refer
  class Referral < ApplicationRecord
    belongs_to :referrer, polymorphic: true
    belongs_to :referee, polymorphic: true
    belongs_to :referral_code, optional: true, counter_cache: true

    before_validation do
      self.referrer = referral_code&.referrer
    end

    def complete!(**attributes)
      update attributes.with_defaults(completed_at: Time.current)
    end
  end
end
