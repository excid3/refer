module Refer
  class ReferralCode < ApplicationRecord
    belongs_to :referrer, polymorphic: true
    has_many :referrals, dependent: :nullify

    validates :code, presence: true, uniqueness: true

    before_create if: -> { Refer.code_generator } do
      Refer.code_generator.call(referrer)
    end

    def to_param
      code
    end
  end
end
