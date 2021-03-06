# encoding: utf-8
class Clientrecipe < ActiveRecord::Base
  
  belongs_to :recipe
  belongs_to :client
  
  attr_accessible :price, :recipe_id, :client_id
  
  validates :price, presence: { :message => "Hinta on pakollinen" }
  validates_numericality_of :price, { :greater_than_or_equal_to => 0, :message => "Hinnan täytyy olla positiivinen numero!" }
  
end
