class LearningObject
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :description, :type => String
  key :name

  references_many :exercises, :dependent => :delete

  validates_presence_of :name, :description
  validates_uniqueness_of :name
end
