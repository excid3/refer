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

  test "can be completed" do
    referral = refer_referrals(:one)
    assert_nil referral.completed_at

    travel_to Time.current do
      referral.complete!
      assert_equal Time.current, referral.completed_at
    end
  end

  test "complete with custom attributes" do
    referral = refer_referrals(:one)
    assert_nil referral.completed_at

    travel_to Time.current do
      referral.complete!(completed_at: 1.hour.ago)
      assert_equal 1.hour.ago, referral.completed_at
    end
  end
end
