class Exercise
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :title
  field :enunciation
  field :position, :type => Integer
  slug :title

  referenced_in :learning_object

  references_many :questions
  embeds_one :fractal_exercise

  has_many :answers, dependent: :destroy

  validates_presence_of :title, :enunciation, :fractal_exercise, :fractal
  validates_associated :learning_object, :fractal_exercise
  validates_uniqueness_of :title

  before_create :set_position
  after_update :update_questions_correct_answers

  def markdown_desc
    options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis, :fenced_code, :gh_blockcode]
    Redcarpet.new(self.enunciation, *options).to_html.html_safe
  end

  def fractal
    fractal_exercise
  end

  def tokens
    _questions = questions.order_by([[ :position, :asc ]]).map {|question| question.tokens }
    {length: self.questions.length, questions: _questions}
  end

  def last_user_answers(user)
    questions.order_by([[ :position, :asc ]]).map do |question|
      question.correct_answers.order_by([[ :iteration, :asc ]]).map do |correct_answer|
        last_answer = correct_answer.last_user_answers.where(user_id: user.id).last
        last_answer ? {response: last_answer.response, correct: last_answer.correct} : {}
      end
    end
  end

private
  def set_position
    lo = learning_object.exercises.order_by([[ :position, :desc ]])
    if (lo.empty?)
      self.position= 1
    else
      self.position= lo.first.position + 1
    end
  end

  # needs update questions answers as iterations
  def update_questions_correct_answers
      self.questions.each {|question| question.update_correct_answers}
  end
end
