class LearningGroup
  include Mongoid::Document

  field :code, :type => String
  field :name, :type => String

  referenced_in :user
  has_and_belongs_to_many :learning_objects

  has_and_belongs_to_many :users
end
