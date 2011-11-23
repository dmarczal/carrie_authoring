class Fractal
  include Mongoid::Document
  key :name

  field :name
  field :iterations, :type => Integer
  field :angle, :type => Integer
  field :axiom
  field :rules, :type => Array

  references_many :exercises

  validates_uniqueness_of :name
end
