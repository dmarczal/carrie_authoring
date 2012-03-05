#encoding: utf-8
class Published::FractalsController < ApplicationController


  def show
    @lo = LearningObject.find_by_slug(params[:id])
    @pages = Kaminari.paginate_array(@lo.pages).page(params[:page]).per(1)
    @page = @pages.first

    c = 0;
    @pagination = @lo.pages.map {|page| ["#{page.class.model_name.human} #{c+=1}: #{page.title}", c]}
    breadcumb(@page)
  end

private
  def breadcumb(page)
    if page.instance_of? Introduction
      add_breadcrumb "OA #{@lo.name} - Introdução", :published_fractal_path
    else
      add_breadcrumb "OA #{@lo.name} - Exercício", :published_fractal_path
    end
  end
end
