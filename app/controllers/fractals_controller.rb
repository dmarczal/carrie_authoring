class FractalsController < ApplicationController

  def update_size
    Fractal.find(params[:id]).update_attributes({width: params[:width].to_f, height: params[:height].to_f})
    render nothing: true;
  end

end
