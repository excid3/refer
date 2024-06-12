class Refer::ModelGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def migrations
    rails_command "refer:install:migrations"
  end

  def add_refer
    inject_into_class File.join("app", "models", "#{file_path}.rb"), class_name, "  has_referrals\n"
  end
end
