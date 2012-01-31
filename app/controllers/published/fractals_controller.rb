class Published::FractalsController < ApplicationController
  def index
  end

  def show
    @oa = LearningObject.first
    @introduction = @oa.introductions.first
  end
end
