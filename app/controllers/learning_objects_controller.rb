#encoding: utf-8
class LearningObjectsController < ApplicationController

  before_filter :authenticate_user!
  load_and_authorize_resource :find_by => :slug

  add_breadcrumb "Objetos de Aprendizagem", :learning_objects_path

  def index
    @learning_objects = current_user.learning_objects.order_by([[:created_at, :desc]]).page(params[:page]).per(6)

    if params[:q]
      @lo_json = current_user.learning_objects.where(name: /#{params[:q]}/i)
      respond_to do |format|
        format.json { render :json => @lo_json.map(&:token_inputs) }
      end
    end
  end

  def show
    @learning_object = current_user.learning_objects.find_by_slug(params[:id])
    @exercises = @learning_object.exercises.order_by([[ :position, :asc ]])
    @introductions = @learning_object.introductions.order_by([[ :position, :asc ]])

    add_breadcrumb "OA: #{@learning_object.name}", learning_object_path(@learning_object_path)
  end

  def new
    @learning_object = current_user.learning_objects.new
    add_breadcrumb "Novo Objeto de Aprendizagem", :new_learning_object_path
  end

  def edit
    @learning_object = current_user.learning_objects.find_by_slug(params[:id])
    add_breadcrumb "Editar #{@learning_object.name}", :edit_learning_object_path
  end

  def create
    @learning_object = current_user.learning_objects.new(params[:learning_object])

    if @learning_object.save
      redirect_to @learning_object, notice: 'OA criado com sucesso.'
    else
      render :new
    end
  end

  def update
    @learning_object = current_user.learning_objects.find_by_slug(params[:id])

    respond_to do |format|
      if  @learning_object.update_attributes(params[:learning_object])
        format.html { redirect_to(@learning_object,
                      notice: "As informações do OA #{@learning_object.name} foram atualizadas.") }
        format.json { respond_with_bip(@learning_object) }
      else
        format.html { render :edit }
        format.json { respond_with_bip(@learning_object) }
      end
    end
  end

  def destroy
    @learning_object = current_user.learning_objects.find_by_slug(params[:id])
    @learning_object.destroy

    redirect_to learning_objects_url, notice: "OA deletado com sucesso"
  end

  def sort_exercises
    params[:exercise].each_with_index do |id, index|
      Exercise.find(id).update_attribute(:position, index+1)
    end
    render nothing: true
  end

  def sort_introductions
    params[:introduction].each_with_index do |id, index|
      Introduction.find(id).update_attribute(:position, index+1)
    end
    render nothing: true
  end

end
