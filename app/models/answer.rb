class Answer
  include Mongoid::Document
  include Mongoid::Timestamps

  field :correct, type: Boolean
  field :response
  field :right_response

  belongs_to :user
  belongs_to :correct_answer
  belongs_to :question
  belongs_to :exercise
  belongs_to :learning_object

  validates :correct, :inclusion => {:in => [true, false]}
  validates_associated :correct_answer, :user
  validates_presence_of :response

  def correct_answer
    question.correct_answers.find(correct_answer_id)
  end

  def question
    exercise.questions.find(question_id)
  end

  def exercise
    learning_object.exercises.find(exercise_id)
  end
end
