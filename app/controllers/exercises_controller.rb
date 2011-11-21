class ExercisesController < ApplicationController
  def create
    @learning_object = LearningObject.find(params[:learning_object_id])
    @learning_object.exercises.create!(params[:exercise])
    redirect_to @learning_object, :notice => "Exercise Created"
  end

  def show
    @learning_object = LearningObject.find(params[:learning_object_id])
    @exercise = @learning_object.exercises.find(params[:id])
  end

end
