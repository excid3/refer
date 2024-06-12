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

  test "referrals" do
    assert_includes users(:one).referrals, refer_referrals(:one)
  end

  test "referral" do
    assert_equal refer_referrals(:one), users(:two).referral
  end

  test "referrer" do
    assert_equal users(:one), users(:two).referrer
  end
end
