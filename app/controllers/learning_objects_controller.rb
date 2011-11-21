class LearningObjectsController < ApplicationController
  # GET /learning_objects
  # GET /learning_objects.json
  def index
    @learning_objects = LearningObject.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @learning_objects }
    end
  end

  # GET /learning_objects/1
  # GET /learning_objects/1.json
  def show
    @learning_object = LearningObject.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @learning_object }
    end
  end

  # GET /learning_objects/new
  # GET /learning_objects/new.json
  def new
    @learning_object = LearningObject.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @learning_object }
    end
  end

  # GET /learning_objects/1/edit
  def edit
    @learning_object = LearningObject.find(params[:id])
  end

  # POST /learning_objects
  # POST /learning_objects.json
  def create
    @learning_object = LearningObject.new(params[:learning_object])

    respond_to do |format|
      if @learning_object.save
        format.html { redirect_to @learning_object, notice: 'Learning object was successfully created.' }
        format.json { render json: @learning_object, status: :created, location: @learning_object }
      else
        format.html { render action: "new" }
        format.json { render json: @learning_object.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /learning_objects/1
  # PUT /learning_objects/1.json
  def update
    @learning_object = LearningObject.find(params[:id])

    respond_to do |format|
      if @learning_object.update_attributes(params[:learning_object])
        format.html { redirect_to @learning_object, notice: 'Learning object was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @learning_object.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /learning_objects/1
  # DELETE /learning_objects/1.json
  def destroy
    @learning_object = LearningObject.find(params[:id])
    @learning_object.destroy

    respond_to do |format|
      format.html { redirect_to learning_objects_url }
      format.json { head :ok }
    end
  end
end
