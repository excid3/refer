module Refer
  class Engine < ::Rails::Engine
    isolate_namespace Refer

    initializer "refer.hooks" do
      ActiveSupport.on_load(:active_record) do
        include Refer::HasReferrals
      end

      ActiveSupport.on_load(:action_controller) do
        include Refer::Controller
      end
    end
  end
end
