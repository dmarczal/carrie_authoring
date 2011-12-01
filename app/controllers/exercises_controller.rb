#encoding: utf-8
class ExercisesController < ApplicationController

  before_filter :find_learning_object, :only => [:create, :new, :show]

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

  # for on_sot TODO: do this in a better way
  def update_attribute_on_the_spot
    klass, field, id = params[:id].split('__')
    select_data = params[:select_array]

    object = LearningObject.find(params[:learning_object_id]).exercises.find(id)

    if object.update_attributes(field => params[:value])
      if select_data.nil?
        render :text => CGI::escapeHTML(object.send(field).to_s)
      else
        parsed_data = JSON.parse(select_data.gsub("'", '"'))
        render :text => parsed_data[object.send(field).to_s]
      end
    else
      render :text => object.errors.full_messages.join("\n"), :status => 422
    end
  end


  def show
    @exercise = @learning_object.exercises.find(params[:id])
    @fractals = Fractal.all.map{|fractal| [fractal.id, fractal.name]}

    add_breadcrumb "Exercício: #{@exercise.title}", :learning_object_exercise_path
  end

  private
  def find_learning_object
    @learning_object = LearningObject.find(params[:learning_object_id])

    add_breadcrumb "Objetos de Aprendizagem", learning_objects_path
    add_breadcrumb "OA: #{@learning_object.name}", learning_object_path(@learning_object)
  end

end
