class Fractal
  include Mongoid::Document
  include Mongoid::Slug

  slug :name

  field :name
  field :angle, :type => Integer
  field :axiom
  field :constant
  field :rules

  validates_uniqueness_of :name
  validates_presence_of :name, :angle, :axiom, :rules
end
