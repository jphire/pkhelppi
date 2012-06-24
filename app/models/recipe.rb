# encoding: utf-8
# == Schema Information
#
# Table name: recipes
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null

class Recipe < ActiveRecord::Base
  has_many :hasmaterials
  has_many :materials, :through => :hasmaterials
  
  belongs_to :bakery
  
  attr_accessible :name, :price, :bakery
  validates :name, presence: { :message => "Nimi on pakollinen" }, :length => { :minimum => 2, :maximum => 50, :message => "Nimen täytyy olla 2-50 merkkiä pitkä" }
  validates_numericality_of :price, { :greater_than_or_equal_to => 0, :message => "Hinnan täytyy olla positiivinen numero!" }
  #validates_uniqueness_of :materials
  
  def update_price
    self.price = 0
    self.hasmaterials.each do |material|
      price = Material.find(material.material_id).price
      self.price += (material.amount/1000 * price)
    end
    self.save
  end
  
  def save
    super
  end
  
  def self.search(search, page)
    paginate :per_page => 5, :page => page,
           :conditions => ['name like ?', "%#{search}%"],
           :order => 'name'
  end
end