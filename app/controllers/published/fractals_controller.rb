#encoding: utf-8
class Published::FractalsController < ApplicationController


  def show
    @lo = LearningObject.find_by_slug(params[:id])

    intro = @lo.introductions.order_by([[ :position, :asc ]])
    exer = @lo.exercises.order_by([[ :position, :asc ]])
    pages = intro + exer

    c = 0;
    intro = intro.map {|page| ["Introdução #{c+=1}: #{page.title}", c] }
    exer = exer.map  {|page| ["Exercício #{c+=1}: #{page.title}", c] }

    @pagination = intro + exer
    @pages = Kaminari.paginate_array(pages).page(params[:page]).per(1)
    @page = @pages.first

    add_breadcrumb "OA #{@lo.name}", :published_fractal_path
  end

end
