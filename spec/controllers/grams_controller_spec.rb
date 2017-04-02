require 'rails_helper'

RSpec.describe GramsController, type: :controller do
  describe "grams#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#new action" do 
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the new form" do
      user = FactoryGirl.create(:user)
      sign_in user

      get :new #this goes through the route and calls it in the grams controller. then sends back response.
      expect(response).to have_http_status(:success)
      #byebug
    end
    it "should successfully instantiate a new gram" do 
      #this goes directly to the grams controller without going through the route. Testing controller new method returns type gram.
      expect(GramsController.new.new.class).to eq(Gram)
    end
  end

  #look up return value of the new action

  describe "grams#create action" do

    it "should require users to be logged in" do
      post :create, params: { gram: { message: "Hello"} }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully create a new gram in our database" do
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, params: { gram: { message: "Hello!"} }
      expect(response).to redirect_to root_path

      gram = Gram.last
      expect(gram.message).to eq("Hello!")
      expect(gram.user).to eq(user)
    end

      it "should properly deal with validation errors" do
        user = FactoryGirl.create(:user)
        sign_in user

        gram_count = Gram.count
        post :create, params: { gram: {message: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(gram_count).to eq 0
      end

  end
end
