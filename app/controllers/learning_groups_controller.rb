#encoding: utf-8
class LearningGroupsController < ApplicationController

  load_and_authorize_resource find_by: :slug
  add_breadcrumb "Turmas", :learning_groups_path

  def index
    @learning_groups = LearningGroup.where(owner_id: current_user.id)
  end

  def show
    @learning_group = LearningGroup.where(owner_id: current_user.id).find_by_slug(params[:id])
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

#  def matriculate
#    @learning_group = LearningGroup.find_by_slug(params[:learning_group_id])
#    add_breadcrumb "Matricular na turma #{@learning_group.name}", :learning_group_matriculate_path
#  end
#
#  def matriculate_user
#    puts params
#    @learning_group = LearningGroup.find_by_slug(params[:learning_group_id])
#
#    if @learning_group.code == params[:code]
#      @learning_group.user_ids += [current_user.id.to_s]
#      @learning_group.save
#      current_user.learning_group_ids += [@learning_group.id.to_s]
#      current_user.save
#      redirect_to learning_groups_path, :notice => "Matriculado na turma #{@learning_group.name}"
#    else
#      flash[:alert] = "Código errado"
#      redirect_to learning_group_matriculate_path(@learning_group)
#    end
#  end
end
