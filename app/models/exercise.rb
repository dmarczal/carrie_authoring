class Exercise
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :enunciation
  field :position, :type => Integer

  referenced_in :learning_object
  referenced_in :fractal

  embeds_many :questions

  validates_presence_of :fractal, :title, :enunciation
  validates_associated :fractal
  validates_associated :learning_object

  #before_create :set_position

  #def set_position
    #lo = learning_object.exercises
    #self.position= lo.desc(:position) ? lo.first.position + 1 : 1
  #end
end
