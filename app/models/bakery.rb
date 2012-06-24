# == Schema Information
#
# Table name: bakeries
#
#  id          :integer         not null, primary key
#  description :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Bakery < ActiveRecord::Base
  has_one :firm, :as => :resource
  has_many :recipes
  has_many :materials
  
  attr_accessible :description, :firm
  validates :description, presence: true, :length => { :maximum => 500 }
  
end
