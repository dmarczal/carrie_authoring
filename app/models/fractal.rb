class Fractal
  include Mongoid::Document
  key :name

  field :name
  field :iterations, :type => Integer
  field :angle, :type => Integer
  field :axiom
  field :rules, :type => Array
  field :width , :type => Float, default: 128
  field :height, :type => Float, default: 128

  references_many :exercises

  validates_uniqueness_of :name
  validates_numericality_of :height, greater_than: 10, less_than: 512
  validates_numericality_of :width, greater_than: 10, less_than: 512

  def dimension
    return [width, height]
  end
end
