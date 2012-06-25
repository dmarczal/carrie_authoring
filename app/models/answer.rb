class Answer
  include Mongoid::Document
  include Mongoid::Timestamps

  field :lo, type: Hash
  field :exercise, type: Hash
  field :question, type: Hash
  field :correct_answer, type: Hash

  field :exercise_responses, type: Hash
  field :response
  field :right_response
  field :correct, type: Boolean

  belongs_to :user
  embeds_many :comments, :as => :commentable
  index({ comments: 1})

  validates_associated :user
  accepts_nested_attributes_for :comments


  default_scope order_by([:created_at, :desc])

  scope :wrong, where(correct: false)
  scope :corrects, where(correct: true)

  index({ correct: 1 }, {name: "correct_index" })

  def self.find_by_lo(slug)
    where('lo.slug' => slug)
  end

  def lo=(lo)
    super lo.as_json
  end

  def lo
    _lo = super
    LearningObject.new(_lo) rescue nil
  end

  def exercise=(exercise)
    super exercise.as_json(include: {questions: {include: :correct_answers}})
  end

  def question=(question)
    super question.as_json
  end

  def question
    _question = super
    Question.new(_question) rescue nil
  end

  def correct_answer=(correct_answer)
    super correct_answer.as_json
  end

  def correct_answer
    _correct_answer = super
    CorrectAnswer.new(_correct_answer) rescue nil
  end

  # Tokens to build the questions
  def tokens
    length = exercise['questions'].length
    questions = exercise['questions']
    qs = questions.map do |question|
       answers = question['correct_answers'].map do |answer|
          {id: answer['_id'], ask: answer['ask'], response: answer['response']}
       end
      {answers: answers}
    end
    {length: length, questions: qs}
  end


  # Verifiy retroaction answer
  require 'math_eql_exp'
  include ::MathEqlExp

  def verify_answer(params)
    ca_resp = find_correct_response(params[:question_id], params[:correct_answer_id])
    response = params[:response]
    begin
      if ca_resp.eql?("any")
        correct = true
      else
        replace_response(ca_resp, params[:question_responses])
        correct = eqlMathExp?(ca_resp, response, {n: 0.8, l: 311.43});
      end
    rescue Exception => e
      correct = false
    end
  end

  def find_comments_recursively(id)
    find_recursively(id, comments)
  end

private
  def find_correct_response(question_id, correct_answer_id)
    question = exercise['questions'].detect{|q| q['_id'] == BSON::ObjectId(question_id)}
    correct_answer = question['correct_answers'].detect do |ca|
                        ca['_id'] == BSON::ObjectId(correct_answer_id)
                     end
    correct_answer['response']
  end

  def find_recursively(id, elements)
    elements.each do |element|
      if element.id === BSON::ObjectId(id)
        return element
      else
        el = find_recursively(id, element.child_comments)
        return el if el
      end
    end
    nil
  end

end
