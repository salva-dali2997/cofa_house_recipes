class CreateFeedbacks < ActiveRecord::Migration[8.1]
  def change
    create_table :feedbacks do |t|
      t.references :recipe, null: false, foreign_key: true
      t.string :name
      t.text :comment, null: false

      t.timestamps
    end
  end
end
