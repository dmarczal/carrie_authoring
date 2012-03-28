#encoding: utf-8
class AnswersController < ApplicationController

  before_filter :authenticate_user!
  #load_and_authorize_resource

  def errors
    @lo = LearningObject.find_by_slug(params[:id])
    @errors = current_user.answers.where(correct: false, learning_object_id: @lo.id ).order_by([[ :created_at, :desc ]])
  end

  def user_errors
    user = User.find(params[:id])
    @lo = LearningObject.find_by_slug(params[:learning_object_id])
    @errors = user.answers.where(correct: false, learning_object_id: @lo.id).order_by([[ :created_at, :desc ]])
  end
end
