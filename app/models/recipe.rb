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
  
  @@tax = 0.14
  has_many :hasmaterials
  has_many :materials, :through => :hasmaterials
  
  #recipe-recipe association
  has_many :hasrecipes
  has_many :subrecipes, :through => :hasrecipes
  
  has_many :inverse_hasrecipes, :class_name => "Hasrecipe", :foreign_key => "subrecipe_id"
  has_many :parent_recipes, :through => :inverse_hasrecipes, :source => :recipe
  
  has_many :clientrecipes
  has_many :clients, :through => :clientrecipes
  
  belongs_to :bakery
  
  attr_accessible :name, :bakery, :coverage, :product
  validates :name, presence: { :message => "Nimi on pakollinen" }, :length => { :minimum => 2, :maximum => 50, :message => "Nimen täytyy olla 2-50 merkkiä pitkä" }, :uniqueness => { :message => "Reseptin nimi on jo käytössä" }
  validates_numericality_of :coverage, { :greater_than_or_equal_to => 0, :message => "Katteen täytyy olla positiivinen numero!" }
  
  validate :subrecipes_cannot_form_circular_dependencies, :on => :update
  
  def subrecipes_cannot_form_circular_dependencies
    name = self.name
    if self.subrecipes.any? { |s| s.has_circular? name }
      errors.add(:subrecipes_cannot, "form circular dependencies")
    end
  end
  
  def get_price
    price = 0
    self.hasmaterials.each do |material|
      temp_price = Material.find(material.material_id).price
      price += (material.amount/1000 * temp_price)
    end
    
    self.subrecipes.each do |subrecipe|
      amount = self.hasrecipes.find_by_subrecipe_id(subrecipe.id).amount
      price += subrecipe.get_price * amount
    end
    price.round(2)
  end
  
  def tax
    price = self.get_coveraged_price * @@tax
    price.round(2)
  end
  
  def get_taxed_price
    price = self.get_coveraged_price
    price += (@@tax * price)
    price.round(2)
  end
  
  def get_coveraged_price
    price = self.get_price
    price += (self.coverage/100 * price)
    price.round(2)
  end
  
  def get_weight
    self.hasmaterials.sum(:amount) + self.subrecipes_sum
  end
  
  def subrecipes_sum
    amount_sum = 0.0
    self.subrecipes.each do |subrecipe|
      amount = self.hasrecipes.find_by_subrecipe_id(subrecipe.id).amount 
      amount_sum += amount * subrecipe.get_weight 
      #(amount * subrecipe.materials.sum(:amount).to_f)
    end
    amount_sum
  end
  
  def self.get_tax
    @@tax
  end
  
  def self.set_tax(tax)
    @@tax = tax
  end
  
  def self.search(search, page)
    paginate :per_page => 15, :page => page,
           :conditions => ['name like ?', "%#{search}%"],
           :order => 'name'
  end
  
  def has_circular?(name)
    if name == self.name
      return true
    else
      return self.subrecipes.any? { |r| r.has_circular? name }
    end
  end
  
end
