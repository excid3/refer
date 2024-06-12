module Refer
  module Controller
    extend ActiveSupport::Concern

    def set_refer_cookie
      if (code = params[Refer.param_name])
        cookies[Refer.cookie_name] = Refer.cookie(code)
      end
    end

    def refer(referee)
      Refer.refer(code: cookies[Refer.cookie_name], referee: referee)
    end
  end
end
