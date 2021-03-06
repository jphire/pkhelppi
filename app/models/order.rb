# encoding: utf-8
class Order < ActiveRecord::Base
  belongs_to :suborder, :polymorphic => true, :autosave => true
  belongs_to :client
  belongs_to :bill
  
  attr_accessible :suborder, :client_id, :description, :bill_id
  suborder_list = ["Bakeryorder"]
  
  validates :client, presence: { :message => "Asiakas pitää olla määritetty." }
  
  #validates :suborder_type, presence: { :message => "Laskun tyyppi on pakollinen" }
  #validates :suborder_id, presence: { :message => "Laskutyypin id on pakollinen" }
  #validates_inclusion_of :suborder_type, :in => suborder_list, :allow_nil => false, :message => "Laskutyypin täytyy olla joku seuraavista: #{suborder_list}"
  
  def get_total_amount
    self.suborder.get_total_amount
  end
end
