class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, :type => String
  field :enunciation, :type => String
  field :answer, :type => String

  referenced_in :exercise, :inverse_of => :questions

  validates_presence_of :title, :enunciation, :answer
  validates_associated :exercise
end
