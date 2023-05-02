class CreateDawnBootNetworkstatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :dawn_boot_networkstatuses do |t|
      t.boolean :success
      t.boolean :inprogress
      t.json    :testresults
      t.timestamps
    end
  end
end
