# -*- coding: utf-8 -*-
class RepresentativesController < ApplicationController
  unloadable
  verify :params => :client_id, :redirect_to => { :controller => 'clients', :action => 'index' }
  before_filter :find_client
  before_filter :find_representative, :only => [:edit, :update, :destroy]

  def new
    @representative = @client.reps.new
  end

  def create
    @representative = @client.reps.new(params[:representative])
    if @representative.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to client_url(@client)
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @representative.update_attributes(params[:representative])
      flash[:notice] = l(:notice_successful_update)
      redirect_to client_url(@client)
    else
      render :action => "edit"
    end
  end

  def destroy
    @representative.destroy
    flash[:notice] = l(:notice_successful_delete)
    redirect_to client_url(@client)
  end

  private
  def find_client
    @client = Client.find(params[:client_id])
  end

  def find_representative
    @representative = Representative.find(params[:id])
  end
end
