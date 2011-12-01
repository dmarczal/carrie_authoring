class Exercise
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :enunciation
  field :position, :type => Integer
  key :title

  referenced_in :learning_object
  referenced_in :fractal

  embeds_many :questions

  validates_presence_of :fractal, :title, :enunciation
  validates_associated :fractal
  validates_associated :learning_object
  validates_uniqueness_of :title

  before_create :set_position

private
  def set_position
    lo = learning_object.exercises.order_by([[ :position, :desc ]])
    if (lo.empty?)
      self.position= 1
    else
      self.position= lo.first.position + 1
    end
  end
end
