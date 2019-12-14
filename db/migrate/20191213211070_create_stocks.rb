class CreateStocks < ActiveRecord::Migration[6.0]
  def change
    create_table :stocks, id: :uuid do |t|
      t.belongs_to :bearer, type: :uuid, null: false, foreign_key: true
      t.string :name, null: false
      t.boolean :is_deleted, null: false, default: false
      t.timestamps
    end
  end
end
