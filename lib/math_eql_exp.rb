module MathEqlExp
  require 'math_engine'

  def replace_response(response, question_responses)
    if response.match(/resp_(\d+)/)
      it = response.match(/resp_(\d+)/)[1].to_i
      response.gsub!("resp_#{it}", question_responses[it])
    end
    response
  end

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
