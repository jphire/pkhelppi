# == Schema Information
#
# Table name: materials
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Material < ActiveRecord::Base
  has_and_belongs_to_many :recipes
  belongs_to :firm
    
  attr_accessible :name, :firm
  validates :name, presence: true, :length => { :maximum => 50 }

end
