class Introduction
  include Mongoid::Document
  include Mongoid::Slug

  field :title
  field :content
  slug :title

  referenced_in :learning_object

  validates_presence_of :title, :content
  validates_associated :learning_object
end
