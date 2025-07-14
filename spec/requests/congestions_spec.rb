require 'rails_helper'

RSpec.describe "Congestions", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/congestions/create"
      expect(response).to have_http_status(:success)
    end
  end

end
