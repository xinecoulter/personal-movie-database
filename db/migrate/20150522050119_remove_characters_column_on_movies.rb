class RemoveCharactersColumnOnMovies < ActiveRecord::Migration
  def change
    remove_column :movies, :characters
  end
end
