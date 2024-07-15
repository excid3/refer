require "test_helper"

module Refer
  class VisitTest < ActiveSupport::TestCase
    test "masks ips" do
      assert_equal "127.0.0.0", Refer::Visit.new(ip: "127.0.0.1").ip
    end

    test "referring_domain" do
      request = ActiveSupport::OrderedOptions.new.merge(referrer: "https://gorails.com/episodes/1")
      assert_equal "gorails.com", Refer::Visit.from_request(request).referring_domain
    end
  end
end
