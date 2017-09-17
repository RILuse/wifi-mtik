class WifiLoginForm
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include ActiveRecord::Persistence
  include ActiveModel::Model

  attr_accessor :phone, :order, :code, :registration, :login
  validates :phone, presence: true
  validates :order, presence: true, numericality: {only_integer: true}, if: :registration?
  validates :code, presence: true, numericality: {only_integer: true}, if: :login?


  def registration?
    registration == true
  end

  def login?
    login == true
  end



end