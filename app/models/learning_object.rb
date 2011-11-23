class LearningObject
  include Mongoid::Document
  field :name, :type => String
  field :description, :type => String

  references_many :exercises, :dependent => :delete

  validates_presence_of :name, :description
end
