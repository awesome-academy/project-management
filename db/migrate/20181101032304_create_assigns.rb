class CreateAssigns < ActiveRecord::Migration[5.2]
  def change
    create_table :assigns do |t|
      t.references :card, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :assigns, [:card_id, :user_id], unique: true
  end
end
