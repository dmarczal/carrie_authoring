class CorrectAnswer
  #include Mongoid::Document


  def Math.factorial(a) 
  	f = a.downto(1).inject(:*)
  	return f
  end


  def self.eql?(correct_formula, user_answer, first, it) 
  	first = eval(first).to_f;
  	correct_formula = correct_formula.gsub('sqrt', 'Math.sqrt')
  	correct_formula = correct_formula.gsub('X', first.to_s)
  	correct_formula = correct_formula.gsub('It', it)
  	correct_formula = correct_formula.gsub("^", "**")
    if (it.to_i == 0)
      return true
    end

    correct_answer = eval(correct_formula)
    return correct_answer == user_answer.to_f
  end

end
