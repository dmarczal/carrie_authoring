#encoding: utf-8
class AnswersController < ApplicationController

  before_filter :authenticate_user!

  def errors
    @lo = LearningObject.find_by_slug(params[:id])
    @errors = current_user.answers.where(correct: false, learning_object_id: @lo.id ).order_by([[ :created_at, :desc ]])
    authorize! :errors, Answer
  end

  def user_errors
    authorize! :user_errors, Answer
    user = User.find(params[:id])
    @lo = LearningObject.find_by_slug(params[:learning_object_id])
    @errors = user.answers.where(correct: false, learning_object_id: @lo.id).order_by([[ :created_at, :desc ]])
  end
end
