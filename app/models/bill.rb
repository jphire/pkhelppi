# encoding: utf-8
class Bill < ActiveRecord::Base
  belongs_to :client
  belongs_to :firm
  has_many :orders
  
attr_accessible :client_id, :firm_id, :reference_number, :due_date, :dated_at, :payment_condition, :bank, :info, :bill_number, :delay_interest
  
  validates :reference_number, presence: { :message => "Viitenumero on pakollinen" }
  validates :bank, presence: { :message => "Pankki on pakollinen" }
  validates :bill_number, presence: { :message => "Laskun numero on pakollinen" }
  validates :client, presence: { :message => "Asiakas pitää olla määritetty." }
  
  validates_numericality_of :reference_number, { :greater_than_or_equal_to => 0, :message => "Viitenumeron täytyy olla positiivinen numero!" }
  validates_numericality_of :bill_number, { :greater_than_or_equal_to => 0, :message => "Laskun numeron täytyy olla positiivinen numero!" }

  @@tax = 0.14
  
  def self.get_banks
    ["Nordea", "Sampo", "Osuuspankki"]
  end
  
  def get_total_amount
    amount = 0
    
    self.orders.each do |o|
      amount += o.get_total_amount
    end
    amount
  end
  
  def get_total_amount_with_taxes
    amount = self.get_total_amount 
    (amount + amount * @@tax).round(2)
  end
  
  def self.get_tax
    @@tax
  end
end
