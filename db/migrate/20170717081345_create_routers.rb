class CreateRouters < ActiveRecord::Migration[5.1]
  def change
    create_table :routers do |t|
      t.string :identity,              null: false, default: ""
      t.string :ip,              null: false, default: ""
      t.string :login,              null: false, default: ""
      t.string :password,              null: false, default: ""
      t.string :port,              null: false, default: ""
      t.timestamps
    end
  end
end
