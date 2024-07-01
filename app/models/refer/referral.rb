module Refer
  class Referral < ApplicationRecord
    belongs_to :referrer, polymorphic: true
    belongs_to :referee, polymorphic: true
    belongs_to :referral_code, optional: true, counter_cache: true

    before_validation do
      self.referrer = referral_code&.referrer
    end
  end
end
