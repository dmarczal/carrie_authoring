class FractalsController < ApplicationController

  before_filter :load_breadcrumb

  def index
    @fractals = Fractal.all
  end

  def show
    @fractal = Fractal.find_by_slug(params[:id])
    render :json => @fractal
  end

  def new
    add_breadcrumb "Novo fractal", :new_fractal_path
    @fractal = Fractal.new
  end

  def create
    @fractal = Fractal.new(params[:fractal])

    if @fractal.save
      redirect_to @fractal, notice: 'Fractal criado com sucesso.'
    else
      render :new
    end
  end

  def destroy
    @fractal = Fractal.find_by_slug(params[:id])
    if @fractal then @fractal.destroy end

    redirect_to fractal_path, notice: "Fractal deletado com sucesso"
  end

private
  def load_breadcrumb
    add_breadcrumb "Fractais", fractals_path
  end
end
