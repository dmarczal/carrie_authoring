# encoding: utf-8
require 'spec_helper'

describe "LearningObjects" do
  describe "GET /published/fractals/:learning_object/preview" do

    before(:each) do
      @user = Fabricate(:user)
      @lo = Fabricate(:learning_object, user: @user)
    end

    it "It should redirect to login page when the user is not logged" do
      visit preview_published_fractal_path(@lo)
      page.should have_content("Você precisa fazer login ou inscrever-se antes de continuar.")
    end

    it "It should access the preivew if the user is logged in" do
      login(@user)
      visit preview_published_fractal_path(@lo)
      page.should have_content("Preview #{@lo.name}")
    end

    it "It should not access the preivew if the user is not the owner of the learning object " do
      user = Fabricate(:user)
      login(user)
      visit preview_published_fractal_path(@lo)
      page.should have_content("Você não possui acesso à essa página!")
    end
  end

  describe "GET /published/fractals/:learning_object", :focus => true do

    before(:each) do
      @user = Fabricate(:user)
      @lo = Fabricate(:learning_object, user: @user)
      @lg = Fabricate(:learning_group, onwer_id: @user.id)
      @lg.users << @user
      @lg.learning_objects << @lo
    end

    it "It should redirect to login page when the user is not logged" do
      visit published_fractal_path(@lo)
      page.should have_content("Você precisa fazer login ou inscrever-se antes de continuar.")
    end

    it "It should access the learning object if the user belongs to the same group of the learning object" do
      login(@user)
      visit published_fractal_path(@lo)
      page.should have_content(@lo.name)
    end

    it "It should access the learning object if the user belongs to the same group of the learning object as student" do
      user = Fabricate(:user, type: :student)
      login(user)
      @lg.users << user
      visit published_fractal_path(@lo)
      page.should have_content(@lo.name)
    end

    it "It should not access the learning object if the user belongs to the same group of the learning object" do
      user = Fabricate(:user)
      login(user)
      visit published_fractal_path(@lo)
      page.should have_content("Você não possui acesso à essa página!")
    end
  end

  def login(user)
    visit new_user_session_path
    fill_in "Email", :with => user.email
    fill_in "Password", :with => '1234567'
    click_button "Entrar"
  end
end
