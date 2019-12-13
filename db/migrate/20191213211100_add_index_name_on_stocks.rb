class AddIndexNameOnStocks < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!
  safety_assured

  def change
    add_index :stocks, :name, unique: true, algorithm: :concurrently
  end
end
