#encoding: utf-8
class IntroductionsController < ApplicationController
  before_filter :find_learning_object

  def create
    @introduction = @learning_object.introductions.new
    @introduction.title = params[:introduction][:title]
    @introduction.content = params[:introduction][:content]

    if @introduction.save
      redirect_to @learning_object, :notice => "Introdução criada com sucesso"
    else
      render :new
    end
  end

  def new
    @introduction = @learning_object.introductions.new
    add_breadcrumb "Novo Exercício #{@introduction.title}", :new_learning_object_introduction_path
  end

  def show
    @introduction = @learning_object.introductions.find_by_slug(params[:id])

    add_breadcrumb "Exercício: #{@introduction.title}", :learning_object_introduction_path
  end

  def edit
    @introduction = @learning_object.introductions.find_by_slug(params[:id])
  end

  def update
      @introduction = @learning_object.introductions.find_by_slug(params[:id])
      @introduction.title = params[:introduction][:title]
      @introduction.content = params[:introduction][:content]

      respond_to do |format|
        if @introduction.save
          format.html { redirect_to(@learning_object,
                        notice: "As informações da introdução #{@introduction.title} foram atualizadas.") }
        else
          format.html { render :edit }
        end
      end
  end

  def destroy
    @introduction = @learning_object.introductions.find_by_slug(params[:id]);
    @introduction.destroy

    redirect_to @learning_object, notice: "Introdução deletado com sucesso"
  end

private
  def find_learning_object
    @learning_object = LearningObject.find_by_slug(params[:learning_object_id])

    add_breadcrumb "Objetos de Aprendizagem", learning_objects_path
    add_breadcrumb "OA: #{@learning_object.name}", learning_object_path(@learning_object)
  end
end
