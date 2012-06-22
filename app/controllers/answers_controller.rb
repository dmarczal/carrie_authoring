#encoding: utf-8
class AnswersController < ApplicationController

  before_filter :authenticate_user!

  def errors
    @answers = current_user_answers.wrong
  end

  def corrects
    @answers = current_user_answers.corrects
  end

  def user_errors
    @answers = user_answers.wrong
    render 'errors'
  end

  def user_corrects
    @answers = user_answers.corrects
    render 'corrects'
  end

  def show
     @answer = Answer.find(params[:id])
  end

  #for correct the retroaction answer
  def verify_answer
    answer = Answer.find(params[:id])

    respond_to do |format|
      if answer.verify_answer(params)
        format.json { render :json => true }
      else
        format.json { render :json => false }
      end
    end
  end

private
  def user_answers
    authorize! :user_answers, Answer
    user = User.find(params[:id])
    @lo = LearningObject.find_by_slug(params[:learning_object_id])
    user.answers.find_by_lo(@lo.slug)
  end

  def current_user_answers
    authorize! :answers, Answer
    @lo = LearningObject.find_by_slug(params[:id])
    current_user.answers.find_by_lo(@lo.slug)
  end
end
