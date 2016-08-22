class CreatePhgalleries < ActiveRecord::Migration
  def change
    create_table :phgalleries do |t|

      t.timestamps null: false
    end
  end
end
