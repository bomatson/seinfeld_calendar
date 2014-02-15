require 'spec_helper'

describe UsersController do

  describe 'POST create' do
    context 'given a valid user' do
      subject do
        post :create, user: attributes_for(:user)
      end

      it 'creates a new user' do
        expect{ subject }.to change(User, :count).by(1)
      end

      it 'redirects to the user' do
        subject
        expect(response).to redirect_to User.last
      end
    end

    context 'given a invalid user' do
      let(:invalid_attrs) { {github_username: nil} }

      before do
        post :create, user: invalid_attrs
      end

      it 'redirects to new' do
        expect(response).to render_template :new
      end
    end
  end
end
