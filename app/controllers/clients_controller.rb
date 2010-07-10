# -*- coding: utf-8 -*-
class ClientsController < ApplicationController
  unloadable

  verify :method => :put, :only => :purchase, :redirect_to => { :action => 'index' }
  verify :method => :put, :only => :leave, :redirect_to => { :action => 'index' }

  before_filter :find_client, :only => [:show, :edit, :update, :purchase, :leave, :destroy]

  def index
      @clients = if params[:field] and params[:value]
                   Client.filter(params[:field], params[:value])
                 else
                   Client.all
                 end
  end

  def show
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(params[:client])
    if @client.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to client_url(@client)
    else
      render :action => 'new'
    end
  end

  def csv_import
    if Client.csv_import(params[:csv])
      flash[:notice] = l(:notice_successful_create)
      redirect_to clients_url
    else
      flash[:error] = "CSVインポートに失敗しました。"
      redirect_to new_client_url
    end
  end

  def edit
  end

  def update
    if @client.update_attributes(params[:client])
      flash[:notice] = l(:notice_successful_update)
      redirect_to client_url(@client)
    else
      render :action => "edit"
    end
  end

  def purchase
    @client.projects.push Project.find(params[:project_id])
    update_products
  end

  def leave
    @client.projects.delete Project.find(params[:project_id])
    update_products
  end

  def destroy
    @client.destroy
    flash[:notice] = l(:notice_successful_delete)
    redirect_to clients_url
  end

  private
  def find_client
    @client = Client.find(params[:id])
  end

  def update_products
    respond_to do |format|
      format.html { redirect_to client_url(@client) }
      format.js do
        render :update do |page|
          page.replace_html "projects", :partial => 'projects'
          page << "$('purchase-form').show();" if action_name == 'purchase'

          page.replace_html "versions", :partial => 'versions'
        end
      end
    end
  end
end
