class RenameMovieActorsToRolesAndAddCharacterName < ActiveRecord::Migration
  def change
    rename_table :movie_actors, :roles
    add_column :roles, :character_name, :string
  end
end
