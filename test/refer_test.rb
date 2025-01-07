require "test_helper"

class ReferTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert Refer::VERSION
  end

  test "refer" do
    assert_difference "Refer::Referral.count" do
      Refer.refer(code: refer_referral_codes(:one).code, referee: users(:new))
    end
  end

  test "refer invalid code" do
    assert_raises ActiveRecord::RecordNotFound do
      Refer.refer!(code: "invalid", referee: users(:new))
    end
  end

  test "refer self" do
    assert_no_difference "Refer::Referral.count" do
      Refer.refer(code: refer_referral_codes(:one).code, referee: users(:one))
    end
  end

  test "refer already referred" do
    assert_no_difference "Refer::Referral.count" do
      Refer.refer(code: refer_referral_codes(:one).code, referee: users(:two))
    end

    assert_raises Refer::AlreadyReferred do
      Refer.refer!(code: refer_referral_codes(:one).code, referee: users(:two))
    end
  end

  test "referred?" do
    assert Refer.referred?(users(:two))
    assert_not Refer.referred?(users(:new))
  end

  test "referral_codes" do
    assert_includes users(:one).referral_codes, refer_referral_codes(:one)
  end

  test "referrals" do
    assert_includes users(:one).referrals, refer_referrals(:one)
  end

  test "referral" do
    assert_equal refer_referrals(:one), users(:two).referral
  end

  test "referrer" do
    assert_equal users(:one), users(:two).referrer
  end

  test "referrer when nil" do
    assert_nil users(:new).referrer
  end

  test "referral_completed callback" do
    old_callback = Refer.referral_completed
    referral = refer_referrals(:one)
    assert_not referral.completed_at?

    completed = nil
    Refer.referral_completed = ->(referral) {
      completed = referral
    }

    # Called the first time a referral is completed
    referral.complete!
    assert_equal referral, completed

    # Does not get called second time because referral was already completed
    completed = nil
    referral.complete!
    assert_nil completed
  ensure
    Refer.referral_completed = old_callback
  end
end
