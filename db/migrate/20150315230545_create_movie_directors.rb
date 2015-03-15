class CreateMovieDirectors < ActiveRecord::Migration
  def change
    create_table :movie_directors do |t|
      t.integer :movie_id
      t.integer :director_id

      t.timestamps
    end
  end
end
