class CreateCards < ActiveRecord::Migration[5.1]
  def change
    create_table :cards do |t|
      t.references :user, foreign_key: true
      t.references :task, foreign_key: true
      t.string :name
      t.text :describe
      t.boolean :activated

      t.timestamps
    end
  end
end
