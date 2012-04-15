class CorrectAnswer
  include Mongoid::Document
  include Mongoid::Timestamps

  field :response
  field :ask, type: Boolean
  field :iteration, type: Integer

  validates_presence_of :response, :iteration
  validates :ask, :inclusion => {:in => [true, false]}

  belongs_to :question, inverse_of: :correct_answers
  has_many :answers, dependent: :destroy
  has_many :last_user_answers, dependent: :delete

  validates_associated :question

  after_update :update_answers

  def tokens
    {id: _id, ask: ask, response: (ask? ? "" : response)}
  end


private
  # After the teacher update one correct answer is necessary reload all the
  # answers of the users
  def update_answers
    answers.each do |answer|
      answer.correct= (answer.response.to_f == self.response.to_f)
      answer.save!
    end

    last_user_answers.each do |lua|
      lua.correct= (lua.response.to_f == self.response.to_f)
      lua.save!
    end
  end
end
