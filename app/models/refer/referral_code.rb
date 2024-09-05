module Refer
  class ReferralCode < ApplicationRecord
    belongs_to :referrer, polymorphic: true
    has_many :referrals, dependent: :nullify
    has_many :visits, dependent: :delete_all

    validates :code, presence: true, uniqueness: true

    before_validation if: -> { Refer.code_generator } do
      self.code = Refer.code_generator.call(referrer) unless self.code
    end

    def to_param
      code
    end

    def track_visit(request)
      visits.from_request(request).save
    end
  end
end
