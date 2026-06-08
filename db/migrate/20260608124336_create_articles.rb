class CreateArticles < ActiveRecord::Migration[8.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.integer :status
      t.integer :reports_count
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
