class Exercise
  include Mongoid::Document

  field :title, :type => String
  field :enunciation, :type => String

  field :position, :type => Integer

  referenced_in :learning_object
  referenced_in :fractal

  embeds_many :questions
end
