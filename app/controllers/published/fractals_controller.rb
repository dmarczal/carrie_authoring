#encoding: utf-8
class Published::FractalsController < ApplicationController

  def show
    published_fractal
    breadcumb(@page)

    @pagination_url = "/published/fractals/#{@lo.slug}/page/"
    @save = true
  end

  def preview
    published_fractal
    breadcumb(@page, preview=" - Preview")

    @pagination_url = "/published/fractals/#{@lo.slug}/preview/page/"
    @save = false
  end

private
  def published_fractal
    @lo = LearningObject.find_by_slug(params[:id])
    @pages = Kaminari.paginate_array(@lo.pages).page(params[:page]).per(1)
    @page = @pages.first
    @pagination = @lo.pages_with_name
  end

  def breadcumb(page, preview = "")
    if page.instance_of? Introduction
      add_breadcrumb "OA #{@lo.name} - Introdução #{preview}", :published_fractal_path
    else
      add_breadcrumb "OA #{@lo.name} - Exercício #{preview}", :published_fractal_path
    end
  end
end
