class AddFieldToVip < ActiveRecord::Migration[5.0]
  def change
    add_column :vips, :image_uid, :string
  end
end
