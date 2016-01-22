class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :comment

      t.timestamps null: false
    end
  end
end
