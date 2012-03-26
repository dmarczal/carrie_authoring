#encoding: utf-8
class AnswersController < ApplicationController

  before_filter :authenticate_user!
  load_and_authorize_resource

  def errors
    @errors = current_user.answers.where(correct: false).order_by([[ :created_at, :desc ]])
  end

end
