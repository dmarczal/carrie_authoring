class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, :type => String
  field :enunciation, :type => String

  referenced_in :exercise, :inverse_of => :questions

  has_many :correct_answers, dependent: :destroy
  has_many :answers, dependent: :destroy
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
  def correct_answer?(id, value, question_answers)
    correct_answer = correct_answers.find(id)
    correct_response = correct_answer.response
    iteration = correct_answer.iteration

    if correct_response.eql?("any")
      return true
    else
      if correct_response.match(/resp_(\d+)/)
        it = correct_response.match(/resp_(\d+)/)[1].to_i
        correct_response.gsub!("resp_#{it}", question_answers[it])
      end
      return eqlMathExp?(correct_response, value, {n: 0.8, l: 311.43});
    end
  end

  def correct_and_save_answer?(id, value, question_answers, user, lo, exercise, question)
    correct_answer = correct_answers.find(id)
    correct_response = correct_answer.response

    if correct_response.match(/resp_(\d+)/)
      it = correct_response.match(/resp_(\d+)/)[1].to_i
      correct_response.gsub!("resp_#{it}", question_answers[it])
    end

    correct = correct_answer?(id, value, question_answers)

    answer = Answer.create!(user: user, response: value, correct_answer_id: id, correct: correct,
                  learning_object: lo, exercise: exercise, question: question, right_response: correct_response)

    LastUserAnswer.create_or_update(answer)
    correct
  end

private
  require 'math_engine'

  def eqlMathExp?(exp_a, exp_b, variables = {})
    evaluate(exp_a, variables) == evaluate(exp_b, variables)
  end

  def evaluate(exp, variables)
    engine = MathEngine::MathEngine.new
    variables.each do |key, value|
      engine.evaluate("#{key} = #{value}")
    end
    engine.evaluate(exp)
  end
end
