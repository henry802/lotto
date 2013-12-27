class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.float :price
      t.integer :gid
      t.string :name
      t.float :sold
      t.float :outstanding
      t.float :numtix
      t.float :ratio

      t.timestamps
    end
  end
end
