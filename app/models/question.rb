class Question
  include Mongoid::Document
  field :title, :type => String
  field :enunciation, :type => String
  field :answer, :type => String

  embedded_in :exercise, :inverse_of => :questions

  validates_presence_of :title, :enunciation
  validates_associated :exercise
end
