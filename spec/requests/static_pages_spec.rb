# encoding: utf-8
require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    let(:user) { FactoryGirl.create(:user) }

    after { User.delete_all }

    before do
      sign_in user
      visit root_path
    end
    
    it { should have_selector('h1',    text: 'Yritykset') }
    it { should have_selector('title', text: full_title('')) }
    it { should_not have_selector 'title', text: '| Koti' }
  end

  describe "Help page" do
    before { visit help_path }

    it { should have_selector('h1',    text: 'Help') }
    it { should have_selector('title', text: full_title('Help')) }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_selector('h1',    text: 'About') }
    it { should have_selector('title', text: full_title('About Us')) }
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_selector('h1',    text: 'Contact') }
    it { should have_selector('title', text: full_title('Contact')) }
  end
  
  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About Us')
    click_link "Contact"
    page.should # fill in
    click_link "Koti"
    click_link "Luo käyttäjä!"
    page.should # fill in
    #click_link "devlfin"
    #page.should # fill in
  end
end
