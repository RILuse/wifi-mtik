class HotspotCustomerController < ApplicationController
  before_action :require_admin

  def index
    @hpc = HotspotCustomer.all
  end

  def show_log
    @log = HotspotLog.all
  end

  def new
  end

  def create
  end

  def show
  end

  def update
  end

  def edit
  end
end
