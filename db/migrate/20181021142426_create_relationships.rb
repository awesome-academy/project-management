class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.references :project, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :is_manager

      t.timestamps
    end
  end
end
