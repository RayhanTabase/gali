require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let!(:user) { create(:user, password: 'password') }
  
  describe "POST #create" do
    context "with valid email and password" do
      it "returns a success message" do
        post :create, params: { email: user.email, password: 'password' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({
          "message" => "Login successful!",
          "auth_token" => user.auth_token
        })
      end
    end
    
    context "with invalid email or password" do
      it "returns an error message" do
        post :create, params: { email: user.email, password: 'wrong_password' }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          "message" => "Invalid email or password"
        })
      end
    end
  end
  
  describe "DELETE #destroy" do
    context "when user is logged in" do
      it "returns a success message" do
        request.headers.merge!({ 'Authorization' => "Bearer #{user.auth_token}" })
        delete :destroy
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({
          "message" => "Logged out successfully!"
        })
      end
    end
    
    context "when user is not logged in" do
      it "returns an error message" do
        delete :destroy
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          "message" => "You need to be logged in to perform this action"
        })
      end
    end
  end
end
