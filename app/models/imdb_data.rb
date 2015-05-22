class ImdbData
  def initialize(user_id, imdb_id, storage_id)
    @user_id = user_id
    @imdb_id = imdb_id
    @storage_id = storage_id
    @data = Imdb::Movie.new(@imdb_id)
  end

  def title
    @data.title
  end

  def company
    @data.company
  end

  def length
    @data.length
  end

  def plot
    @data.plot
  end

  def plot_summary
    @data.plot_summary
  end

  def poster
    @data.poster
  end

  def year
    @data.year
  end

  def writers
    @data.writers
  end

  def assign_directors(movie)
    return if movie.invalid?
    @data.director.each do |director|
      movie.directors << Director.find_or_create_by!(name: director)
    end
  end

  def assign_actors_and_roles(movie)
    return if movie.invalid?
    @data.cast_members_characters.each do |cast_member_character|
      actor_role_array = cast_member_character.split(" => ")
      actor = Actor.find_or_create_by!(name: actor_role_array.first)
      Role.create(actor_id: actor.id, movie_id: movie.id, character_name: actor_role_array.last)
    end
  end

  def assign_genres(movie)
    return if movie.invalid?
    @data.genres.each do |genre|
      movie.genres << Genre.find_or_create_by!(name: genre)
    end
  end

  def convert_to_movie
    movie = Movie.create(user_id: @user_id, imdb_identifier: @imdb_id, storage_identifier: @storage_id,
            title: title, company: company, length: length, plot: plot, plot_summary: plot_summary,
            poster: poster, year: year, writers: writers)

    assign_directors(movie)
    assign_actors_and_roles(movie)
    assign_genres(movie)

    movie
  end
end
