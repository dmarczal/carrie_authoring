class FractalsController < ApplicationController

  before_filter :load_breadcrumb

  def index
    @fractals = Fractal.all
  end

  def show
    @fractal = Fractal.find_by_slug(params[:id])
    render :show
  end

  def new
    add_breadcrumb "Novo fractal", :new_fractal_path
    @fractal = Fractal.new
  end

  def create
    @fractal = Fractal.new(params[:fractal])

    # TODO: Do this in a better way, this is necessary for ['FX=F'], FX=F
    rules = params[:fractal][:rules]
    unless rules.empty?
      @fractal.rules= rules.gsub(/\s/, '').split(',')
    end

    if @fractal.save
      redirect_to fractals_path, notice: "Fractal criado com sucesso"
    else
      @fractal.rules= params[:fractal][:rules]
      render :new
    end
  end

  def destroy
    @fractal = Fractal.find_by_slug(params[:id])
    if @fractal then @fractal.destroy end

    redirect_to fractals_path, notice: "Fractal deletado com sucesso"
  end

private
  def load_breadcrumb
    add_breadcrumb "Fractais", fractals_path
  end
end
