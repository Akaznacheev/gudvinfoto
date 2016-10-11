class CreateBookprices < ActiveRecord::Migration
  def change
    create_table :bookprices do |t|
      t.string  :format
      t.string  :status,            :default => "НЕАКТИВЕН"
      t.string  :default,           :default => "НЕТ"
      t.integer :defaultpagescount, :default => 20
      t.integer :cover
      t.integer :page

      t.timestamps null: false
    end
  end
end
