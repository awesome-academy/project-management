class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :name=string
      t.string :describe=text

      t.timestamps
    end
  end
end
