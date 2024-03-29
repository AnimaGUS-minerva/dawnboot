class CreateSystemVariables < ActiveRecord::Migration[7.0]
  def self.up
    create_table :system_variables do |t|
      t.column :configuration_id, :integer
      t.column :variable, :string
      t.column :value,    :string
      t.column :number,   :integer
    end
  end

  def self.down
    drop_table :system_variables
  end
end
