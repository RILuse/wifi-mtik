class RouterController < ApplicationController
  before_action :permit_params
  before_action :require_admin
  before_action :set_router, only: [:show, :update, :edit]
  def index
    @routers = Router.all
  end

  def new
    @router = Router.new
  end

  def create
    @router = Router.new params[:router]
    if @router.valid?
      @router.save!
      flash[:success] = "Роутер #{@router.identity} добавлен"
      redirect_to router_index_url
    else
      render action: :new
    end
  end

  def update
    if @router.update_attributes(params[:router])
      flash[:success] = "Роутер #{@router.identity} обновлен"
      redirect_to "/router/#{@router.id}"
    else
      render action: :edit
    end
  end

  def destroy
  end


  def show

  end

  def edit

  end

  def permit_params
    params.permit!
  end

  def set_router
    @router = Router.find(params[:id])
  end
end
