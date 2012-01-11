#encoding: utf-8
class QuestionsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :load_parents_breadcrumbs

  def new
    @question = @exercise.questions.new
    add_breadcrumb "Nova questão", :new_learning_object_exercise_question_path
  end

  def create
    @question = @exercise.questions.new(params[:question])
    if @question.save
      redirect_to [@learning_object, @exercise], :notice => "Questão criada com sucesso"
    else
      render :new
    end
  end

  private
  def load_parents_breadcrumbs
    @learning_object = LearningObject.find_by_slug(params[:learning_object_id])
    @exercise = @learning_object.exercises.find_by_slug(params[:exercise_id])

    add_breadcrumb "Objetos de Aprendizagem", learning_objects_path
    add_breadcrumb "OA: #{@learning_object.name}", learning_object_path(@learning_object)
    add_breadcrumb "Exercício: #{@exercise.title}", learning_object_exercise_path(@learning_object, @exercise)
  end
end
