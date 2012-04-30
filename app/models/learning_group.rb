#encoding: utf-8
class LearningGroup
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :code, :type => String
  field :name, :type => String
  field :owner_id, :type => Integer

  attr_reader :learning_object_tokens
  attr_accessible :learning_object_tokens, :name, :code, :owner_id

  slug :name

  has_and_belongs_to_many :learning_objects
  has_and_belongs_to_many :users

  validates_presence_of :name, :code
  validates_uniqueness_of :name

  def learning_object_tokens=(ids)
    self.learning_object_ids = ids.split(",")
  end

  def owner
    User.find(self.owner_id)
  end

  def enroll(user, code)
    if code == self.code
      self.errors.messages.delete :enroll
      unless self.users.include?(user)
        self.users << user
        user.learning_groups << self
        self.save
      end
    else
      self.errors.messages[:enroll] = I18n.translate('mongoid.errors.messages.invalid')
    end
  end
end
