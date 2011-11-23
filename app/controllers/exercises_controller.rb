class ExercisesController < ApplicationController

  def create
    @learning_object = LearningObject.find(params[:learning_object_id])
    @learning_object.exercises.create!(params[:exercise])
    redirect_to @learning_object, :notice => "Exercise Created"
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
    @learning_object = LearningObject.find(params[:learning_object_id])
    @exercise = @learning_object.exercises.find(params[:id])
  end

end
