#encoding: utf-8
class QuestionsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :load_parents_breadcrumbs
  load_and_authorize_resource

  def new
    @question = @exercise.questions.new
    @question.load_correct_answers
    @correct_answers = @question.correct_answers
    add_breadcrumb "Nova questão", :new_learning_object_exercise_question_path
  end

  def create
    @question = @exercise.questions.new(params[:question])
    @question.correct_answers.each_with_index {|answer, i| answer.iteration=i}

    if @question.save
      @question.correct_answers.each do |ca|
        ca.save
      end
      redirect_to [@learning_object, @exercise], :notice => "Questão criada com sucesso"
    else
      render :new
    end
  end

  def edit
    @question  = @exercise.questions.find(params[:id])
    @correct_answers = @question.correct_answers.asc(:iteration)
  end

  def update
    @question  = @exercise.questions.find(params[:id])

    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to([@learning_object, @exercise],
                      notice: "A questão #{@question.title} foi atualizada.") }
        format.json { respond_with_bip(@question) }
      else
        @correct_answers = @question.correct_answers.asc(:iteration)
        render :edit
      end
    end
  end

  def destroy
    @question  = @exercise.questions.find(params[:id])
    @question.destroy
    redirect_to [@learning_object, @exercise], notice: "Questão deletada com sucesso"
  end

  def verify_answer
    @question  = @exercise.questions.find(params[:question_id])

    respond_to do |format|
      if @question.correct_answer?(params[:correct_answer_id], params[:response],
                                   params[:question_responses])
        format.json { render :json => true }
      else
        format.json { render :json => false }
      end
    end
  end

  def verify_and_save_answer
    @question  = @exercise.questions.find(params[:question_id])

    respond_to do |format|
      if @question.correct_and_save_answer?(params[:correct_answer_id], params[:response],
                                            params[:question_responses], current_user, @learning_object,
                                            @exercise, @question)
        format.json { render :json => true }
      else
        format.json { render :json => false }
      end
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
