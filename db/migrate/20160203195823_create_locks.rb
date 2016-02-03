class CreateLocks < ActiveRecord::Migration
  def change
    create_table :locks do |t|
      t.integer :resource_id, index: true, null: false
      t.string  :owner,        index: true, limit: 64, null: false

      t.timestamps
    end
  end
end
