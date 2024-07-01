module Refer
  class ReferralCode < ApplicationRecord
    belongs_to :referrer, polymorphic: true
    has_many :referrals, dependent: :nullify

    validates :code, presence: true, uniqueness: true

    before_validation if: -> { Refer.code_generator } do
      self.code = Refer.code_generator.call(referrer)
    end

    def to_param
      code
    end
  end
end
