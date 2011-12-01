#ecoding: utf-8
class LearningObjectsController < ApplicationController
  add_breadcrumb "Objetos de Aprendizagem", :learning_objects_path

  def index
    @learning_objects = LearningObject.all
  end

  def show
    @learning_object = LearningObject.find(params[:id])
    @exercises = @learning_object.exercises.order_by([[ :position, :asc ]])

    add_breadcrumb "OA: #{@learning_object.name}", learning_object_path(@learning_object_path)
  end

  def new
    @learning_object = LearningObject.new
    add_breadcrumb "Novo Objeto de Aprendizagem", :new_learning_object_path
  end

  def edit
    @learning_object = LearningObject.find(params[:id])
    add_breadcrumb "Editar #{@learning_object.name}", :edit_learning_object_path
  end

  def create
    @learning_object = LearningObject.new(params[:learning_object])

    if @learning_object.save
      redirect_to @learning_object, notice: 'OA criado com sucesso.'
    else
      render :new
    end
  end

  def update
    @learning_object = LearningObject.find(params[:id])

    if @learning_object.update_attributes(params[:learning_object])
      redirect_to @learning_object, notice: "As nformações do OA #{@learning_object.name} foram atualizadas."
    else
      render :edit
    end
  end

  def destroy
    @learning_object = LearningObject.find(params[:id])
    @learning_object.destroy

    redirect_to learning_objects_url, notice: "OA deletado com sucesso"
  end

  def sort_exercises
    puts "_-________"
    puts params

    params[:exercise].each_with_index do |id, index|
      Exercise.find(id).update_attribute(:position, index+1)
    end
    render nothing: true
  end
end
