rails g mongoid:config
in initializer/setup_mail.rb
ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "linjingen.com",
  :user_name            => "jelinmscs@gmail.com",
  :password             => "83681600lje.",
  :authentication       => "plain",
  :enable_starttls_auto => true
}
ActionMailer::Base.default_url_options[:host] = "localhost:3000"
config.action_mailer.default_url_options = {
  :host => '127.0.0.1',
  :port => 3000
}
rails g mailer user_mailer
user_mailer.rb in app/mailers/user_mailer.rb
attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
methodname.text.erb in view/user_mailer
UserMailer.registration_confirmation(@user).deliver

rails g devise:install
config/
  /initializers/devise.rb
  /locales/devise.en.yml

rails g devise user
rails g devise:views

facebook:
UrAppZone
App ID: 692880250730465
App Secret: 201d4977c90cfb1aeeaa1a9299cb8932(reset)

gem 'omniauth-facebook'

CONFIG = YAML.load(File.read(File.expand_path('../application.yml', __FILE__)))
CONFIG.merge! CONFIG.fetch(Rails.env, {})
CONFIG.symbolize_keys!

devise.rb
config.omniauth :facebook, CONFIG[:facebook_key], CONFIG[:facebook_secret]

views:
user_omniauth_authorize_path(:facebook)

rails g controller omniauth_callbacks

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user.persisted?
      sign_in_and_redirect user, notice: "Signed in!"
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end
  alias_method :facebook, :all
end

in user.rb
def self.from_omniauth(auth)
  where(auth.slice(:provider, :uid)).first_or_create do |user|
    user.provider = auth.provider
    user.uid = auth.uid
    user.email = auth.info.email
    user.image = Image.new
    user.firstname = auth.info.first_name
    user.lastname = auth.info.last_name
  end
end

def self.new_with_session(params, session)
  if session["devise.user_attributes"]
    new(session["devise.user_attributes"]) do |user|
      user.attributes = params
      user.valid?
    end
  else
    super
  end
end

def password_required?
  super && provider.blank?
end

def update_with_password(params, *options)
  if encrypted_password.blank?
    update_attributes(params, *options)
  else
    super
  end
end

in application_controller.rb
def after_sign_in_path_for(resource)
  "#/dashboard"
end

