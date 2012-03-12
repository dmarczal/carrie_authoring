#encoding: utf-8
class Published::FractalsController < ApplicationController


  def show
    @lo = LearningObject.find_by_slug(params[:id])
    @pages = Kaminari.paginate_array(@lo.pages).page(params[:page]).per(1)
    @page = @pages.first
    @url = "/published/fractals/#{@lo.slug}/page/"

    @pagination = @lo.pages_with_name
    breadcumb(@page)
  end

  def preview
    @lo = LearningObject.find_by_slug(params[:id])
    @pages = Kaminari.paginate_array(@lo.pages).page(params[:page]).per(1)
    @page = @pages.first
    @url = "/published/fractals/#{@lo.slug}/preview/page/"

    @pagination = @lo.pages_with_name
    breadcumb(@page, preview=" - Preview")
  end

private
  def breadcumb(page, preview = "")
    if page.instance_of? Introduction
      add_breadcrumb "OA #{@lo.name} - Introdução #{preview}", :published_fractal_path
    else
      add_breadcrumb "OA #{@lo.name} - Exercício #{preview}", :published_fractal_path
    end
  end
end
