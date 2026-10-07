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

  test "complete! doesn't override previous completion" do
    referral = refer_referrals(:one)
    assert_nil referral.completed_at

    referral.complete!

    travel_to Time.current + 1.hour do
      assert_no_difference "referral.completed_at" do
        referral.complete!
      end
    end
  end

  test "can be created without a referral code" do
    referral = Refer::Referral.create!(referrer: users(:one), referee: users(:new))
    assert_equal users(:one), referral.referrer
  end

  test "can be completed after referral code is destroyed" do
    referral = refer_referrals(:one)
    referral.referral_code.destroy
    referral.reload

    assert referral.complete!
    assert_equal users(:one), referral.referrer
  end

  test "complete! does not call callback if update fails" do
    referral = refer_referrals(:one)
    referral.referee = users(:one) # Self-referral, invalid

    Refer.with(referral_completed: ->(_) { flunk "referral_completed should not be called" }) do
      assert_not referral.complete!
    end
  end

  test "referral_completed is not called if the transaction rolls back" do
    referral = refer_referrals(:one)

    Refer.with(referral_completed: ->(_) { flunk "referral_completed should not be called" }) do
      Refer::Referral.transaction do
        referral.complete!
        raise ActiveRecord::Rollback
      end
    end
  end
end
