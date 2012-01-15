#encoding: utf-8
class QuestionsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :load_parents_breadcrumbs
  load_and_authorize_resource

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

  def edit
    @learning_object = LearningObject.find_by_slug(params[:learning_object_id])
    @exercise = @learning_object.exercises.find_by_slug(params[:exercise_id])
    @question  = @exercise.questions.find(params[:id])
  end

  def update
    @learning_object = LearningObject.find_by_slug(params[:learning_object_id])
    @exercise = @learning_object.exercises.find_by_slug(params[:exercise_id])
    @question  = @exercise.questions.find(params[:id])

    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to([@learning_object, @exercise],
                      notice: "A questão #{@question.title} foi atualizada.") }
        format.json { respond_with_bip(@question) }
      else
        render :edit
      end
    end
  end

  def validate
    @learning_object = LearningObject.find_by_slug(params[:learning_object_id])
    @exercise = @learning_object.exercises.find_by_slug(params[:exercise_id])
    @question  = @exercise.questions.find(params[:question_id])

    respond_to do |format|
      if CorrectAnswer.eql?(@question.answer, params[:answer], params[:first], params[:row])
        format.json { render :json => true }
      else
        format.json { render :json => false }
      end
    end
  end


  def show_form_help
    render :help
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
