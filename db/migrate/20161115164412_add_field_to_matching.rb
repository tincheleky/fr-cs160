class AddFieldToMatching < ActiveRecord::Migration[5.0]
  def change
    add_column :matchings, :image_uid, :string
  end
end
