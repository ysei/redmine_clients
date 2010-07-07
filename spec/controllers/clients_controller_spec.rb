require 'spec_helper'

describe ClientsController do
  def mock_client(stubs={})
    @mock_client ||= mock(stubs)
  end

  describe "GET 'index'" do
    it "assigns all clients as @clients" do
      Client.stub(:all).and_return([mock_client])
      get :index
      assigns[:clients].should == [mock_client]
    end
  end

  describe "GET 'show'" do
    it "assigns the requested client as @client" do
      Client.stub(:find).with("37").and_return(mock_client)
      get :show, :id => "37"
      assigns[:client].should == mock_client
    end
  end

  describe "GET 'new'" do
    it "assings a new client as @client" do
      Client.stub(:new).and_return(mock_client)
      get :new
      assigns[:client].should == mock_client
    end
  end

  describe "GET 'edit'" do
    it "assigns the requested client as @client" do
      Client.stub(:find).with("37").and_return(mock_client)
      get :edit, :id => "37"
      assigns[:client].should == mock_client
    end
  end

  describe "POST 'create'" do
    context "with valid params" do
      before do
        Client.stub(:new).with({ 'these' => 'params' }).and_return(mock_client(:save => true))
        post :create, :client => { :these => 'params' }
      end

      it "assigns a newly created client as @client" do
        assigns[:client].should == mock_client
      end

      it "redirects to the created client" do
        response.should redirect_to client_url(mock_client)
      end
    end

    context "with invalid params" do
      before do
        Client.stub(:new).with({ 'these' => 'params'}).and_return(mock_client(:save => false))
        post :create, :client => { :these => 'params' }
      end

      it "assigns a newly created but unsved account as @client" do
        assigns[:client].should == mock_client
      end

      it "re-renders the 'new' template" do
        response.should render_template('new')
      end
    end
  end

  describe "PUT 'update'" do
    before do
      Client.stub(:find).with("37").and_return(mock_client)
    end

    context "with valid params" do
      before do
        mock_client.stub(:update_attributes).with({ 'these' => 'params' }).and_return(true)
        put :update, :id => "37", :client => { :these => 'params' }
      end

      it "assigns the requested client as @client" do
        assigns[:client].should == mock_client
      end

      it "redirects to the client" do
        response.should redirect_to client_url(mock_client)
      end
    end

    context "with invalid params" do
      before do
        mock_client.stub(:update_attributes).with({ 'these' => 'params' }).and_return(false)
        put :update, :id => "37", :client => { :these => 'params' }
      end

      it "assigns the client as @client" do
        assigns[:client].should == mock_client
      end

      it "re-renders the 'edit' template" do
        response.should render_template('edit')
      end
    end
  end

  describe "PUT 'purchase'" do
    before do
      Client.stub(:find).with("37").and_return(mock_client)
      mock_client.stub_chain(:projects, :push)
    end

    it "put project to client" do
      Project.should_receive(:find).with("20")
      put :purchase, :id => "37", :project_id => "20"
    end

    it "redirects to the client" do
      Project.stub(:find)
      put :purchase, :id => "37", :project_id => "20"
      response.should redirect_to client_url(mock_client)
    end
  end

  describe "PUT 'leave'" do
    before do
      Client.stub(:find).with("37").and_return(mock_client)
      mock_client.stub_chain(:projects, :delete)
    end

    it "remove project from client" do
      Project.should_receive(:find).with("20")
      put :leave, :id => "37", :project_id => "20"
    end

    it "redirects to the client" do
      Project.stub(:find)
      put :leave, :id => "37", :project_id => "20"
      response.should redirect_to client_url(mock_client)
    end
  end

  describe "DELETE 'destroy'" do
    it "destroys the requested client" do
      Client.should_receive(:find).with("37").and_return(mock_client)
      mock_client.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the clients list" do
      Client.stub(:find).and_return(mock_client(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to clients_url
    end
  end
end
