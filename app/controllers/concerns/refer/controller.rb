module Refer
  module Controller
    extend ActiveSupport::Concern

    class_methods do
      def set_referral_cookie(param_name: Refer.param_name, cookie_name: Refer.cookie_name, **options)
        before_action -> { set_refer_cookie(param_name: param_name, cookie_name: cookie_name) }, **options
      end
    end

    def refer(referee, cookie_name: Refer.cookie_name)
      Refer.refer(code: cookies[cookie_name], referee: referee)
    end

    private

    def set_refer_cookie(param_name: Refer.param_name, cookie_name: Refer.cookie_name)
      code = params[param_name]
      return if code.blank?

      cookies[cookie_name] = Refer.cookie(code) if Refer.overwrite_cookie || cookies[cookie_name].blank?
      ReferralCode.find_by(code: code)&.track_visit(request) if Refer.track_visits
    end
  end
end
