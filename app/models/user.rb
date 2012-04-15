#encoding: utf-8
class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
 ## Database authenticatable
  field :email,              :type => String, :null => false
  field :encrypted_password, :type => String, :null => false

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  field :name, :type => String
  field :school, :type => String
  field :type, :type => String

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :accessible

  attr_accessible :email, :password, :password_confirmation, :name, :school, :type

  references_many :learning_group, :dependent => :delete

  has_many :fractals, dependent: :nullify
  has_many :learning_objects, dependent: :nullify
  has_many :answers, dependent: :destroy
  has_many :last_user_answers

  has_and_belongs_to_many :learning_groups

  validates :type, inclusion: { in: %w(professor student admin)}
  validates_uniqueness_of :email

  def student?
      self.type == "student"
  end

  def professor?
    self.type == "professor"
  end

  def admin?
    self.type == "admin"
  end

  def user_type
    if professor?
      I18n.translate('autho.professor')
    elsif student?
      I18n.translate('autho.student')
    else
      self.type
    end
  end

  def name
    unless super.blank?
      super
    else
      I18n.translate('mongoid.attributes.user.unknown')
    end
  end

  def has_name?
    not @name.blank?
  end

end
