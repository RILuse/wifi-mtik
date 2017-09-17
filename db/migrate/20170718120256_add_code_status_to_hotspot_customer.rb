class AddCodeStatusToHotspotCustomer < ActiveRecord::Migration[5.1]
  def change
    add_column :hotspot_customers, :code_status, :boolean, default: false
  end
end
