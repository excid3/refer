module Refer
  class Visit < ApplicationRecord
    belongs_to :referral_code, counter_cache: true
  end
end
