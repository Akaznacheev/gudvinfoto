class CreateSitepages < ActiveRecord::Migration
  def change
    create_table :sitepages do |t|
      t.string :name
      t.string :text
      t.string :question
      t.string :answer

      t.timestamps null: false
    end
  end
end
