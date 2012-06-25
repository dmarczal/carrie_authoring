class CommentsController < ApplicationController

  before_filter :authenticate_user!

  prepend_before_filter :get_model
  before_filter :get_comment, :only => [:show, :edit, :update]

  respond_to :html, :js

  def index
    @comments = @model.comments
    respond_with([@model,@comments])
  end

  def show
    respond_with([@model,@comment])
  end

  def new
    @comment =  @model.comments.build
    if params[:parent]
      parent = @model.find_comments_recursively(params[:parent])
      if parent
        @comment = parent.child_comments.build
      end
    end
    respond_with([@model, @comment])
  end


  def edit
    authorize!(:update, @comment || Comment)
    respond_with([@model,@comment])
  end

  def create
    authorize!(:create, :comments)

    @comment =  @model.comments.build(params[:comment])
    if params[:comment][:parent]
      parent = @model.find_comments_recursively(params[:comment][:parent])
      if parent
        @comment = parent.child_comments.build(params[:comment])
      end
    end
    @comment.user = current_user

    if @comment.save
      flash[:notice] = I18n.t('commentable.actions.create')
    else
      flash[:error] = 'Comment wasn\'t created.'
    end
    respond_with(@model)
  end

  def update
    authorize!(:update, @comment || Comment)
    if @comment.update_attributes(params[:comment])
      flash[:notice] = I18n.t('commentable.actions.update')
    else
      flash[:error] = 'Comment wasn\'t deleted.'
    end
    respond_with([@model,@comment], :location => @model)
  end

  def destroy
    @comment = @model.find_comments_recursively(params[:id])
    authorize!(:destroy, @comment)
    @comment.destroy
    flash[:notice] = I18n.t('commentable.actions.destroy')
    respond_with(@model)
  end

  private

  def classname
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize
      end
    end
  end

  def model_id
    params.each do |name, value|
      if name =~ /.+_id$/
        return name
      end
    end
    nil
  end

  def get_model
    @model = classname.find(params[model_id.to_sym])
  end

  def get_comment
    @comment = @model.find_comments_recursively(params[:id])
  end

end
