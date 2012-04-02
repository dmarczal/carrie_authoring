class CorrectAnswer
  include Mongoid::Document
  include Mongoid::Timestamps

  field :response
  field :ask, type: Boolean
  field :iteration, type: Integer

  validates_presence_of :response, :iteration
  validates :ask, :inclusion => {:in => [true, false]}

  belongs_to :question, inverse_of: :correct_answers
  has_many :answers
  has_many :last_user_answers

  validates_associated :question

  def tokens
    {id: _id, ask: ask, response: (ask? ? "" : response)}
  end
end
