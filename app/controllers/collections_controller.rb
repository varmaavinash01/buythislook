class CollectionsController < ApplicationController
  before_filter :current_user
  before_filter :login_check
  
  def index
    @collections = Collection.all(@user["gender"])
    # TODO filter collections by gender
  end

  def new
  end

  def create
    @collection = Collection.create(params)
    Collection.save(@collection)
    redirect_to :action => "index"
  end

  def show
    @collection = Collection.find(params[:id])
    @collection["created_by"] = User.get(@collection["created_by"])
  end

  def update
  end

  def edit
  end

  def destroy
  end
end
