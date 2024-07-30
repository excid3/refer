module Refer
  module HasReferrals
    extend ActiveSupport::Concern

    class_methods do
      def has_referrals
        include Refer::Model
      end
    end
  end
end
