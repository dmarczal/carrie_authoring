#encoding: utf-8
class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  field :name, :type => String
  field :school, :type => String
  field :type, :type => String

  attr_accessor :accessible

  attr_accessible :email, :password, :password_confirmation, :name, :school, :type

  references_many :learning_group, :dependent => :delete

  has_many :fractals, dependent: :nullify
  has_many :learning_objects

  has_and_belongs_to_many :learning_groups

  validates :type, inclusion: { in: %w(professor student)}
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
