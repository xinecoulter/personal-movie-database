class MovieDecorator < Draper::Decorator
  delegate_all

  def display_directors
    directors.pluck(:name).join(", ")
  end

  def display_genres
    genres.pluck(:name).join(", ")
  end

  def display_writers
    writers.join(", ") if writers.present?
  end

end
