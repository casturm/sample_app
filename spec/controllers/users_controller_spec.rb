require 'spec_helper'

describe UsersController do
  describe "non-admin can't destroy users" do
    before do
      @user = Factory(:user)
      @another_user = Factory(:user)
      sign_in @user
    end

    it "user is not destroyed" do
      expect{
        delete :destroy, id: @another_user
      }.to change(User,:count).by(0)
    end

    it "redirects to root_path" do
      delete :destroy, id: @another_user
      response.should redirect_to root_path
    end
  end

  describe "admin user can destroy other users" do
    before do
      @user = Factory(:user, admin: true)
      @another_user = Factory(:user)
      sign_in @user
    end

    it "user is destroyed" do
      expect{
        delete :destroy, id: @another_user
      }.to change(User,:count).by(-1)
    end

    it "redirects to users_path" do
      delete :destroy, id: @another_user
      response.should redirect_to users_path
    end
  end

  describe "admin user can not destroy himself" do
    before do
      @user = Factory(:user, admin: true)
      sign_in @user
    end

    it "user is not destroyed" do
      expect{
        delete :destroy, id: @user
      }.to change(User,:count).by(0)
    end

    it "redirects to root_path" do
      delete :destroy, id: @user
      response.should redirect_to root_path
    end
  end
end
