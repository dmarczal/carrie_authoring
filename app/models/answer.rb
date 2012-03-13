class Answer
  include Mongoid::Document
  include Mongoid::Timestamps

  field :correct, type: Boolean
  field :response

  belongs_to :user
  belongs_to :correct_answer

  validates :correct, :inclusion => {:in => [true, false]}
  validates_associated :correct_answer, :user
  validates_presence_of :response

  def question
    correct_answer.question
  end

  def exercise
    question.exercise
  end

  def lo
    exercise.learning_object
  end
end
