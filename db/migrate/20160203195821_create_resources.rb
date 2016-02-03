class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :name,   index: true, limit: 64, null: false

      t.timestamps
    end
  end
end
