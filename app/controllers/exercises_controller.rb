#encoding: utf-8
class ExercisesController < ApplicationController

  before_filter :find_learning_object, :only => [:create, :new, :show]

  def create
    @exercise = @learning_object.exercises.new(params[:exercise])
    if @exercise.save
      redirect_to @learning_object, :notice => "Exercício criado com sucesso, defina agora as questões"
    else
      p @exercise.errors
      render :new
    end
  end

  def new
    @exercise = @learning_object.exercises.new
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
  end

  private
  def find_learning_object
    @learning_object = LearningObject.find(params[:learning_object_id])
  end

end
