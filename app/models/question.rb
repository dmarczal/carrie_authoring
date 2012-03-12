class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, :type => String
  field :enunciation, :type => String

  referenced_in :exercise, :inverse_of => :questions
  embeds_many :answers

  validates_presence_of :title, :enunciation
  validates_associated :exercise

  accepts_nested_attributes_for :answers, :allow_destroy => true

  def load_answers
    it = self.exercise.fractal.iterations
    it = self.exercise.fractal.infinite? ? it + 1 : it
    it.times { |i| self.answers.build(iteration: i) }
  end

  # TODO: verify correct answer
  def correct_answer?(id, value)
    answer = answers.find(id)
    return answer.response.to_f === value.to_f
  end

  # Tokens for create exercises
  def tokens
    _answers = answers.map {|an| an.tokens}
    {answers: _answers}
  end

  # needs update answers according iterations
  def update_answers
    frac_its = self.exercise.fractal.iterations
    its = self.answers.size
    value = frac_its - its

    value += 1 if self.exercise.fractal.infinite?

    if value < 0
      value.abs.times { self.answers.last.destroy }
    else
      value.times do
        answer = self.answers.create(iteration: its, response: its, ask: true)
        answer.save
        its += 1
      end
    end
  end
end
