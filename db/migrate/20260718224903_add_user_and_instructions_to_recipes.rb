class AddUserAndInstructionsToRecipes < ActiveRecord::Migration[8.1]
  def change
    add_reference :recipes, :user, null: false, foreign_key: true
    add_column :recipes, :instructions, :text, null: false, default: ""
    change_column_null :recipes, :name, false
  end
end
