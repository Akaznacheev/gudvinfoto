class CreateBookprices < ActiveRecord::Migration
  def change
    create_table :bookprices do |t|
      t.string  :format
      t.string  :status,            :default => "НЕАКТИВЕН"
      t.string  :default,           :default => "НЕТ"
      t.integer :minpagescount,     :default => 20
      t.integer :maxpagescount,     :default => 30
      t.integer :coverprice,        :default => 0
      t.integer :twopageprice,      :default => 0
      t.integer :coverwidth,        :default => 0
      t.integer :coverheight,       :default => 0
      t.integer :twopagewidth,      :default => 0
      t.integer :twopageheight,     :default => 0


      t.timestamps null: false
    end
  end
end
