class FractalsController < ApplicationController

  before_filter :load_breadcrumb

  def update_size
    Fractal.find(params[:id]).update_attributes({width: params[:width].to_f, height: params[:height].to_f})
    render nothing: true;
  end

  def show
    @fractal = Fractal.find(params[:id])
    render :json => @fractal
  end

  def new
    add_breadcrumb "Novo fractal", :new_fractal_path
    @fractal = Fractal.new
  end

  def index
    @fractals = Fractal.all
  end

private
  def load_breadcrumb
    add_breadcrumb "Fractais", fractals_path
  end
end
