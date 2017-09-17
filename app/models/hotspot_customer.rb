class HotspotCustomer < ApplicationRecord
  validates :login, presence: true, uniqueness: true
end
