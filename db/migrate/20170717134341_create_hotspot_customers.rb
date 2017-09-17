class CreateHotspotCustomers < ActiveRecord::Migration[5.1]
  def change
    create_table :hotspot_customers do |t|
      t.string :login, null: false, default: ""
      t.string :password, null: false, default: ""
      t.string :router_id, null: false, default: ""
      t.string :mac, null: false, default: ""
      t.string :ip, null: false, default: ""
      t.timestamps
    end
  end
end
