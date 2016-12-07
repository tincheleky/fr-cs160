class CreateVips < ActiveRecord::Migration[5.0]
  def change
    create_table :vips do |t|
      t.string :img_name
      t.string :img_type
      t.binary :img_data
      t.integer :size

      t.timestamps
    end
  end
end
