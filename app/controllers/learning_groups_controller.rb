#encoding: utf-8
class LearningGroupsController < ApplicationController

  load_and_authorize_resource find_by: :slug
  before_filter :breadcrumb

  def index
    @learning_groups = LearningGroup.where(owner_id: current_user.id)
    @my_groups = current_user.learning_groups
  end

  def show
    @learning_group = LearningGroup.where(owner_id: current_user.id).find_by_slug(params[:id])
    @learning_objects = @learning_group ? @learning_group.learning_objects : []
    add_breadcrumb "Turma: #{@learning_group.name}", learning_group_path(@learning_groups)
  end

  def new
    @learning_group = LearningGroup.new(owner_id: current_user.id)
    add_breadcrumb "Nova Turma", :new_learning_group_path
  end

  def edit
    @learning_group = LearningGroup.where(owner_id: current_user.id).find_by_slug(params[:id])
    add_breadcrumb "Editar #{@learning_group.name}", edit_learning_group_path(@learning_groups)
  end

  def create
    @learning_group = LearningGroup.new(params[:learning_group])
    @learning_group.owner_id = current_user.id

    respond_to do |format|
      if @learning_group.save
        format.html { redirect_to @learning_group, notice: 'Turma cadastrada com sucesso' }
      else
        add_breadcrumb "Nova Turma", :new_learning_group_path
        format.html { render action: "new" }
      end
    end
  end

  def update
    @learning_group = LearningGroup.where(owner_id: current_user.id).find_by_slug(params[:id])

    respond_to do |format|
      if @learning_group.update_attributes(params[:learning_group])
        format.html { redirect_to @learning_group, notice: 'Turma atualizada com sucesso' }
      else
        add_breadcrumb "Editar #{@learning_group.name}", edit_learning_group_path(@learning_groups)
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @learning_group = LearningGroup.where(owner_id: current_user.id).find_by_slug(params[:id])

    respond_to do |format|
      format.html { redirect_to learning_groups_url, notice: 'Turma deletada com sucesso' }
      format.json { head :ok }
    end
  end

  def my_groups
    @learning_groups = current_user.learning_groups
  end

  def my_group
    @learning_group = current_user.learning_groups.find_by_slug(params[:id])
    add_breadcrumb "Turma: #{@learning_group.name}", :my_group_learning_group_path
  end

  def all_groups
    add_breadcrumb "Todas turmas", :all_groups_learning_groups_path
    @learning_groups = LearningGroup.all
  end

  def enroll
    @learning_group = LearningGroup.find_by_slug(params[:learning_group_id])
    @learning_group.enroll(current_user, params[:group_code])
  end

  def learning_object
    @learning_group = current_user.learning_groups.find_by_slug(params[:id])
    @lo = @learning_group.learning_objects.find_by_slug(params[:learning_object])
    breadcrumb
    add_breadcrumb "OA: #{@lo.name}", :learning_object_learning_group_path
  end

private
  def breadcrumb
    if current_user.professor?
      add_breadcrumb "Turmas", :learning_groups_path
    else
      add_breadcrumb "Minhas Turmas", :my_groups_learning_groups_path
    end
  end
end
