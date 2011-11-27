class QuestionsController < ApplicationController
  def create
    @learning_object = LearningObject.find(params[:learning_object_id])
    @exercise = @learning_object.exercises.find(params[:exercise_id])
    @exercise.questions.create!(params[:question])
    redirect_to [@learning_object, @exercise], :notice => "Question Created"
  end

  def new

  end
end
