class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.references :card, foreign_key: true
      t.references :user, foreign_key: true
      t.string :type
      t.text :content

      t.timestamps
    end
  end
end
