require "test_helper"

class ReferralIntegrationTest < ActionDispatch::IntegrationTest
  test "referral is created" do
    assert_difference "Refer::Referral.count" do
      post refer_path(ref: refer_referral_codes(:one), user_id: users(:new).id)
    end
  end

  test "doesn't set referral cookie if param missing" do
    get root_path(other: "example")
    assert_nil cookies[Refer.cookie_name]
  end

  test "sets referral cookie" do
    referral_code = refer_referral_codes(:one)
    get root_path(ref: referral_code)
    assert_equal referral_code.to_param, cookies[Refer.cookie_name]
  end

  test "tracks visits" do
    referral_code = refer_referral_codes(:one)
    assert_difference "referral_code.reload.visits_count" do
      get root_path(ref: referral_code)
    end
  end
end
