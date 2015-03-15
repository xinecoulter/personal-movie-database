class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.integer :imdb_id
      t.string :title
      t.string :company
      t.integer :length
      t.text :plot
      t.text :plot_summary
      t.string :poster
      t.integer :year
      t.string :writers, array: true
      t.text :characters, array: true
      t.integer :user_id
      t.integer :storage_id

      t.timestamps
    end
  end
end
