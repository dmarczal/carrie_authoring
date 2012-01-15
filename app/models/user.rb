class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  field :name, :type => String
  field :is_admin, :type => Boolean
  field :user_type, :type => String

  references_many :learning_group, :dependent => :delete
  has_and_belongs_to_many :learning_group

  def is_teacher?
    self.user_type == "Professor"
  end

  def is_student?
    self.user_type == "Aluno"
  end
end
