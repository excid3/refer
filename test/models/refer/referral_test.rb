require "test_helper"

class Refer::ReferralTest < ActiveSupport::TestCase
  test "referrals are dependent destroyed" do
    assert_difference "Refer::Referral.count", -1 do
      users(:one).destroy
    end
  end

  test "can be associated with a referral code" do
    assert_equal refer_referral_codes(:one), refer_referrals(:one).referral_code
  end
end
