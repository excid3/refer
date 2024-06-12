class Refer::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  def add_refer
    inject_into_class File.join("app", "controllers", "application_controller.rb"), "ApplicationController", "  set_referral_cookie\n"
  end
end
