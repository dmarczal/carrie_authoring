class FractalsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :load_breadcrumb
  load_and_authorize_resource :find_by => :slug

  def index
    @fractals = Fractal.page(params[:page]).per(6)
  end

  def show
    @fractal = Fractal.find_by_slug(params[:id])
    respond_to do |format|
      format.html { render :show }
      format.json { render :json => @fractal }
    end
  end

  def edit
    @fractal = Fractal.find_by_slug(params[:id])
    @fractal.rules = @fractal.rules.join(",")
    add_breadcrumb "Editar #{@fractal.name}", :edit_fractal_path
  end

  def update
    @fractal = Fractal.find_by_slug(params[:id])

    rules = params[:fractal][:rules]
    params[:fractal][:rules] = rules.gsub(/\s/, '').split(',')

    respond_to do |format|
      if  @fractal.update_attributes(params[:fractal])
        format.html { redirect_to(@fractal,
                      notice: "O Fractal #{@fractal.name} foi atualizado.") }
        format.json { respond_with_bip(@fractal) }
      else
        params[:fractal][:rules] = rules
        format.html { render :edit }
        format.json { respond_with_bip(@fractal) }
      end
    end
  end

  def new
    add_breadcrumb "Novo fractal", :new_fractal_path
    session[:return_to] = request.referer
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
      redirect_to session[:return_to], notice: "Fractal criado com sucesso"
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
