class Answer
  include Mongoid::Document
  include Mongoid::Timestamps

  field :response
  field :ask, type: Boolean
  field :iteration, type: Integer

  validates_presence_of :response, :iteration
  validates :ask, :inclusion => {:in => [true, false]}

  embedded_in :question

  validates_associated :question

  def tokens
    {id: _id, ask: ask, response: (ask? ? "" : response) }
  end
end
