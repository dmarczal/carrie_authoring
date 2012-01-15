#encoding: utf-8
class LearningGroupsController < ApplicationController
  # GET /learning_groups
  # GET /learning_groups.json
  add_breadcrumb "Turmas", :learning_groups_path
  def index
    if current_user.is_teacher?
      @learning_groups = LearningGroup.where(user_id: current_user.id)
    else
      @learning_groups = LearningGroup.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @learning_groups }
    end
  end

  # GET /learning_groups/1
  # GET /learning_groups/1.json
  def show
    @learning_group = LearningGroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @learning_group }
    end
  end

  # GET /learning_groups/new
  # GET /learning_groups/new.json
  def new
    @learning_group = LearningGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @learning_group }
    end
  end

  # GET /learning_groups/1/edit
  def edit
    @learning_group = LearningGroup.find(params[:id])
  end

  # POST /learning_groups
  # POST /learning_groups.json
  def create
    @learning_group = LearningGroup.new(params[:learning_group])
    @learning_group.user_id = current_user.id.to_s

    respond_to do |format|
      if @learning_group.save
        format.html { redirect_to @learning_group, notice: 'Learning group was successfully created.' }
        format.json { render json: @learning_group, status: :created, location: @learning_group }
      else
        format.html { render action: "new" }
        format.json { render json: @learning_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /learning_groups/1
  # PUT /learning_groups/1.json
  def update
    @learning_group = LearningGroup.find(params[:id])

    respond_to do |format|
      if @learning_group.update_attributes(params[:learning_group])
        format.html { redirect_to @learning_group, notice: 'Learning group was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @learning_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /learning_groups/1
  # DELETE /learning_groups/1.json
  def destroy
    @learning_group = LearningGroup.find(params[:id])
    @learning_group.destroy

    respond_to do |format|
      format.html { redirect_to learning_groups_url }
      format.json { head :ok }
    end
  end

  def matriculate
    @learning_group = LearningGroup.find(params[:learning_group_id])
    add_breadcrumb "Matricular na turma #{@learning_group.name}", :learning_group_matriculate_path
  end

  def matriculate_user
    puts params
    @learning_group = LearningGroup.find(params[:learning_group_id])

    if @learning_group.code == params[:code]
      @learning_group.user_ids += [current_user.id.to_s]
      @learning_group.save
      current_user.learning_group_ids += [@learning_group.id.to_s]
      current_user.save
      redirect_to learning_groups_path, :notice => "Matriculado na turma #{@learning_group.name}"
    else
      flash[:alert] = "Código errado"
      redirect_to learning_group_matriculate_path(@learning_group)
    end
  end
end