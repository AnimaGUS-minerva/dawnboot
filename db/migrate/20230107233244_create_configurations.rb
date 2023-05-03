class CreateConfigurations < ActiveRecord::Migration[7.0]
  def change
    create_table :dawn_boot_configurations do |t|
      t.text :name
      t.boolean :active
      t.datetime :lastused_at

      t.timestamps
    end
  end
end
