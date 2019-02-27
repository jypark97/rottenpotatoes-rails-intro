class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  # def index
  #   @movies = Movie.all
  # end
  def index
    @all_ratings = Movie.order(:rating).select(:rating).map(&:rating).uniq
    @checked_ratings = check
    session[:ratings] = @checked_ratings
    session[:ratings].each do |rating|
      params[rating] = true
    end
    if params[:sort_by]
      session[:sort_by] = params[:sort_by]
    end
    @movies = Movie.all.where(:rating => session[:ratings]).order(session[:sort_by])
   if session[:sort_by] == 'title'
      @title_header = 'hilite'
    elsif session[:sort_by] == 'release_date'
      @release_header ='hilite'
   end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def check
    if params[:ratings].blank?
      @all_ratings
    elsif params[:ratings]
      params[:ratings].keys
    elsif session[:ratings]
      session[:ratings]
    end
  end

end
