class Question
  include Mongoid::Document
  field :title, :type => String
  field :enunciation, :type => String

  embedded_in :exercise, :inverse_of => :questions
end
