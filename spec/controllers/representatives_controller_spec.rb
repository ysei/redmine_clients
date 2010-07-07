require 'spec_helper'

describe RepresentativesController do
  def mock_rep(stubs={})
    @mock_rep ||= mock(stubs)
  end

  def mock_client(stubs={})
    @mock_client ||= mock(stubs)
  end

  before do
    Client.stub(:find).with("18").and_return(mock_client)
  end

  describe "GET 'new'" do
    it "assings a new representative's representative as @representative" do
      mock_client.stub_chain(:reps, :new).and_return(mock_rep)
      get :new, :client_id => "18"
      assigns[:representative].should == mock_rep
    end
  end

  describe "GET 'edit'" do
    it "assigns the requested representative as @representative" do
      Representative.stub(:find).with("37").and_return(mock_rep)
      get :edit, :client_id => "18", :id => "37"
      assigns[:representative].should == mock_rep
    end
  end

  describe "POST 'create'" do
    context "with valid params" do
      before do
        mock_client.stub_chain(:reps, :new).with({ 'these' => 'params' }).and_return(mock_rep(:save => true))
        post :create, :client_id => "18", :representative => { :these => 'params' }
      end

      it "assigns a newly created representative as @representative" do
        assigns[:representative].should == mock_rep
      end

      it "redirects to the client" do
        response.should redirect_to client_url(mock_client)
      end
    end

    context "with invalid params" do
      before do
        mock_client.stub_chain(:reps, :new).with({ 'these' => 'params'}).and_return(mock_rep(:save => false))
        post :create, :client_id => "18", :representative => { :these => 'params' }
      end

      it "assigns a newly created but unsved account as @representative" do
        assigns[:representative].should == mock_rep
      end

      it "re-renders the 'new' template" do
        response.should render_template('new')
      end
    end
  end

  describe "PUT 'update'" do
    before do
      Representative.stub(:find).with("37").and_return(mock_rep)
    end

    context "with valid params" do
      before do
        mock_rep.stub(:update_attributes).with({ 'these' => 'params' }).and_return(true)
        put :update, :client_id => "18", :id => "37", :representative => { :these => 'params' }
      end

      it "assigns the requested representative as @representative" do
        assigns[:representative].should == mock_rep
      end

      it "redirects to the client" do
        response.should redirect_to client_url(mock_client)
      end
    end

    context "with invalid params" do
      before do
        mock_rep.stub(:update_attributes).with({ 'these' => 'params' }).and_return(false)
        put :update, :client_id => "18", :id => "37", :representative => { :these => 'params' }
      end

      it "assigns the representative as @representative" do
        assigns[:representative].should == mock_rep
      end

      it "re-renders the 'edit' template" do
        response.should render_template('edit')
      end
    end
  end

  describe "DELETE 'destroy'" do
    it "destroys the requested representative" do
      Representative.should_receive(:find).with("37").and_return(mock_rep)
      mock_rep.should_receive(:destroy)
      delete :destroy, :client_id => "18", :id => "37"
    end

    it "redirects to the representatives list" do
      Representative.stub(:find).and_return(mock_rep(:destroy => true))
      delete :destroy, :client_id => "18", :id => "1"
      response.should redirect_to client_url(mock_client)
    end
  end
end
