class Exercise
  include Mongoid::Document
  field :title, :type => String
  field :enunciation, :type => String

  field :axiom
  field :iterations, :type => Integer

  embedded_in :learning_object, :inverse_of => :exercises
  embeds_many :questions
end
