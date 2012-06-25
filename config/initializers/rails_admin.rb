RailsAdmin.config do |config|

  require 'i18n'
  I18n.default_locale = "pt-br"
  config.authorize_with :cancan

  config.current_user_method { current_user } # auto-generated

  config.main_app_name = ['Carrie Mongodb', 'Admin']

  config.included_models = [User, LearningObject]
end
