class CreateMatchings < ActiveRecord::Migration[5.0]
  def change
    create_table :matchings do |t|

      t.timestamps
    end
  end
end
