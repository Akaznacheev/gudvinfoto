class CreateChanges < ActiveRecord::Migration[5.1]
  def change
    create_table :changes do |t|
      t.string :description
      t.string :kind

      t.timestamps
    end
  end
end
