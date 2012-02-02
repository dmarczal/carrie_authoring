class FractalExercise
  include Mongoid::Document
  include Mongoid::Slug

  slug :name

  field :name
  field :angle, :type => Integer
  field :axiom
  field :constant
  field :rules, :type => Array
  field :infinite, :type => Boolean, default: true

  field :iterations, :type => Integer, default: 3
  field :width , :type => Float, default: 128
  field :height, :type => Float, default: 128

  embedded_in :exercise

  validates_uniqueness_of :name
  validates_presence_of :name, :angle, :axiom, :rules, :width, :height, :iterations

  validates_numericality_of :height, greater_than: 10, less_than: 512
  validates_numericality_of :width, greater_than: 10, less_than: 512
end
