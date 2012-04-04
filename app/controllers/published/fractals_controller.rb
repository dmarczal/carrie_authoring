#encoding: utf-8
class Published::FractalsController < ApplicationController

  before_filter :authenticate_user!

  def show
    published_fractal
    breadcumb

    if @page.instance_of? Exercise
      @last_answers = @page.last_user_answers(current_user)
    end

    @pagination_url = "/published/fractals/#{@lo.slug}/page/"
    @save = true
    authorize! :view_published_learning_object, @lo
  end

  def preview
    published_fractal
    breadcumb_preview

    @pagination_url = "/published/fractals/#{@lo.slug}/preview/page/"
    @save = false
    authorize! :manage, @lo
  end

  def destroy
    lo = LearningObject.find_by_slug(params[:learning_object_id])
    authorize! :view_published_learning_object, lo
    exer = lo.exercises.find_by_slug(params[:id])
    exer.answers.each do |answer|
        answer.correct_answer.last_user_answers.destroy
    end
    redirect_to action: :show, id: lo.slug, page: (exer.position + lo.introductions.count)
  end


private
  def published_fractal
    @lo = LearningObject.find_by_slug(params[:id])
    @pages = Kaminari.paginate_array(@lo.pages).page(params[:page]).per(1)
    @page = @pages.first
    @pagination = @lo.pages_with_name
  end

  def breadcumb_preview
    if @page.instance_of? Introduction
      add_breadcrumb "OA #{@lo.name} - Introdução Preview", preview_published_fractal_path
    else
      add_breadcrumb "OA #{@lo.name} - Exercício Preview", preview_published_fractal_path
    end
  end

  def breadcumb
    if @page.instance_of? Introduction
      add_breadcrumb "OA #{@lo.name} - Introdução ", published_fractal_path
    else
      add_breadcrumb "OA #{@lo.name} - Exercício ", published_fractal_path
    end
  end
end
