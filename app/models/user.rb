class User
  include Mongoid::Document
  include Mongoid::Paperclip
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :set_unique_id

  has_many :documents
  has_many :videos
  has_many :donations
  
  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  #added
  has_mongoid_attached_file :avatar,
                            :styles => { 
                              :small => "50x50^",
                              :medium => "200x200^"
                            },
                            :default_url => '/img/blank.png',
                            :url => "/assets/avatar/:id/:style/:basename.:extension",
                            :path => ":rails_root/public/assets/avatar/:id/:style/:basename.:extension"


  # Confirmable
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email,    :type => String # Only if using reconfirmable

  # facebook omniauth
  field :provider, :type => String
  field :uid, :type      => String

  # uniq short id
  field :unique_id, :type => Integer, :default => 1
  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String

  # protected
  def self.author
    where(email: "linjingen@hotmail.com").first
  end

  def self.admin
    where(email: "urappzone@gmail.com").first
  end
  
  def set_unique_id
    self.set(:unique_id => User.count)
  end

  def self.from_omniauth(auth)
    exist_user = where(email: auth.info.email)
    if exist_user.exists?
      exist_user.first
    else
      create(
        provider: auth.provider,
        uid:      auth.uid,
        email:    auth.info.email
      )
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
  # def confirmation_required?
  #   false
  # end

  # def avatar_from_url(url)
  #   avatar = URI.parse(url)
  # end
end
