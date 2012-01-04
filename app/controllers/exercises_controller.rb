#encoding: utf-8
class ExercisesController < ApplicationController

  before_filter :find_learning_object, :only => [:create, :new, :show, :update]

  def create
    @exercise = @learning_object.exercises.new(params[:exercise])
    if @exercise.save
      redirect_to @learning_object, :notice => "Exercício criado com sucesso, defina agora as questões"
    else
      render :new
    end
  end

  def new
    @exercise = @learning_object.exercises.new
    add_breadcrumb "Novo Exercício #{@exercise.title}", :new_learning_object_exercise_path
  end


  def update
    @exercise = @learning_object.exercises.find_by_slug(params[:id])

    respond_to do |format|
      if  @exercise.update_attributes(params[:exercise])
        format.html { redirect_to(@exercise,
                      notice: "As nformações do Exercício #{@exercise.title} foram atualizadas.") }
        format.json { respond_with_bip(@exercise) }
      else
        format.html { render :edit }
        format.json { respond_with_bip(@exercise) }
      end
    end
  end

  def show
    @exercise = @learning_object.exercises.find_by_slug(params[:id])
    @fractals = Fractal.all.map{|fractal| [fractal.id, fractal.name]}

    add_breadcrumb "Exercício: #{@exercise.title}", :learning_object_exercise_path
  end

private
  def find_learning_object
    @learning_object = LearningObject.find_by_slug(params[:learning_object_id])

    add_breadcrumb "Objetos de Aprendizagem", learning_objects_path
    add_breadcrumb "OA: #{@learning_object.name}", learning_object_path(@learning_object)
  end

end
