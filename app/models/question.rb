class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  require 'math_eql_exp'
  include ::MathEqlExp

  field :title, :type => String
  field :enunciation, :type => String

  referenced_in :exercise, :inverse_of => :questions

  has_many :correct_answers, dependent: :destroy, :order => :iteration.asc
  has_many :last_user_answers, dependent: :destroy

  validates_presence_of :title, :enunciation
  validates_associated :exercise

  accepts_nested_attributes_for :correct_answers, :allow_destroy => true

  def load_correct_answers
    it = self.exercise.fractal.iterations
    it = self.exercise.fractal.infinite? ? it + 1 : it
    it.times { |i| self.correct_answers.build(iteration: i) }
  end

  # Tokens for create exercises
  def tokens
    _correct_answers = correct_answers.asc(:iteration).map {|an| an.tokens}
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


  # TODO: verify correct answer
  def correct_answer?(id, value, question_responses)
    ca = correct_answers.find(id)
    response = ca.response.to_s

    begin
      if response.eql?("any")
        return true
      else
        replace_response(response, question_responses)
        return eqlMathExp?(response, value, {n: 0.8, l: 311.43});
      end
    rescue Exception => e
      return false
    end
  end

  def correct_and_save_answer?(id, value, question_responses, user, lo, exercise, question)
    ca = correct_answers.find(id)
    response = ca.response.to_s

    replace_response(response, question_responses)

    correct = correct_answer?(id, value, question_responses)

    answer = Answer.create!(user: user, lo: lo, exercise: exercise,
                            question: question, correct_answer: ca,
                            response: value, right_response: response, correct: correct)

    LastUserAnswer.create_or_update(answer)
    answer.exercise_responses= exercise.last_user_answers(user)
    answer.save!

    correct
  end
end
