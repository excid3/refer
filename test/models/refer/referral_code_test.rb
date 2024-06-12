require "test_helper"

class Refer::ReferralCodeTest < ActiveSupport::TestCase
  test "deleting referral code doesn't delete referral" do
    referral = refer_referrals(:one)
    assert_not_nil referral.referral_code
    assert_no_difference "Refer::Referral.count" do
      referral.referral_code.destroy
    end
    referral.reload
    assert_nil referral.referral_code
  end

  test "referral codes are dependent destroyed" do
    assert_difference "Refer::ReferralCode.count", -1 do
      users(:one).destroy
    end
  end
end
