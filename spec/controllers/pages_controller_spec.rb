require 'spec_helper'

describe PagesController do

  describe "GET 'root'" do
    before { get :root }

    it "returns http success" do
      expect(response).to be_success
    end
  end

end
