class LearningObject
  include Mongoid::Document
  field :name, :type => String
  field :description, :type => String

  embeds_many :exercises

  validates_presence_of :name, :description
end
