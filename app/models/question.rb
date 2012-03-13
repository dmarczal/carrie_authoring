class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, :type => String
  field :enunciation, :type => String

  referenced_in :exercise, :inverse_of => :questions
  embeds_many :correct_answers

  validates_presence_of :title, :enunciation
  validates_associated :exercise

  accepts_nested_attributes_for :correct_answers, :allow_destroy => true

  def load_correct_answers
    it = self.exercise.fractal.iterations
    it = self.exercise.fractal.infinite? ? it + 1 : it
    it.times { |i| self.correct_answers.build(iteration: i) }
  end

  # TODO: verify correct answer
  def correct_answer?(id, value)
    correct_answer = correct_answers.find(id)
    return correct_answer.response.to_f === value.to_f
  end

  def correct_and_save_answer?(id, value, user)
    correct_answer = correct_answers.find(id)
    correct = correct_answer.response.to_f === value.to_f
    Answer.create!(user: user, response: value, correct_answer: correct_answer, correct: correct)
    correct
  end

  # Tokens for create exercises
  def tokens
    _correct_answers = correct_answers.map {|an| an.tokens}
    {answers: _correct_answers}
  end

  # needs update answers according iterations
  def update_correct_answers
    frac_its = self.exercise.fractal.iterations
    its = self.correct_answers.size
    value = frac_its - its

    value += 1 if self.exercise.fractal.infinite?

    if value < 0
      value.abs.times { self.correct_answers.last.destroy }
    else
      value.times do
        correct_answer = self.correct_answers.create(iteration: its, response: its, ask: true)
        correct_answer.save
        its += 1
      end
    end
  end
end
