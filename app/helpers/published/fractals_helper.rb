module Published::FractalsHelper
  def verify_url(lo, exercise, question, save)
    if save
      learning_object_exercise_question_verify_and_save_answer_path(lo, exercise, question)
    else
      learning_object_exercise_question_verify_answer_path(lo, exercise, question)
    end
  end
end
