class LearningGroup
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :code, :type => String
  field :name, :type => String
  field :owner_id, :type => Integer

  slug :name

  has_and_belongs_to_many :learning_objects
  has_and_belongs_to_many :users

  validates_presence_of :name, :code
  validates_uniqueness_of :name


  def owner
    User.find(self.owner_id)
  end

end
