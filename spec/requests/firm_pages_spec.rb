require 'spec_helper'

describe "Firm pages" do

  subject { page }

  describe "index" do
    let(:firm) { FactoryGirl.create(:firm) }
    let(:user) { FactoryGirl.create(:user) }
    
    before(:all) { 40.times { FactoryGirl.create(:firm) } }
    after(:all)  do
      Firm.delete_all
      Bakery.delete_all
    end

    before(:each) do
      sign_in user
      visit firms_path
    end

    it { should have_selector('title', text: 'Yritykset') }
    it { should have_selector('h1',    text: 'Yritykset') }
    
    describe "pagination" do
      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit firms_path
        end
        it { should have_selector('div.pagination') }

        it "should list each firm" do
          Firm.paginate(page: 1, per_page: 10).each do |firm|
            page.should have_selector('h3', text: firm.name)
          end
        end
      end
    end
  end
end
