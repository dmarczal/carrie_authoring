class LastUserAnswer
  include Mongoid::Document
  include Mongoid::Timestamps

  field :correct, type: Boolean
  field :response

  belongs_to :user
  belongs_to :correct_answer

  validates :correct, :inclusion => {:in => [true, false]}
  validates_associated :correct_answer, :user
  validates_presence_of :response

  def self.create_or_update(answer)
    last_answer = LastUserAnswer.where(user_id: answer.user.id, correct_answer_id: answer.correct_answer_id).last

    unless last_answer
       LastUserAnswer.create!(user: answer.user, response: answer.response,
                             correct_answer: answer.correct_answer, correct: answer.correct)
    else
       last_answer.response= answer.response
       last_answer.correct= answer.correct
       last_answer.save
    end
  end

  def exercise
    correct_answer.exercise
  end
end
