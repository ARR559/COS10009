require 'rubygems'           # Required to use RubyGems package manager
require 'gosu'               # Required for Gosu library

TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)               # Top color for background
BOTTOM_COLOR = Gosu::Color.new(0xFF000000)            # Bottom color for background
SCREEN_WIDTH = 800                                    # Width of the application window
SCREEN_HEIGHT = 600                                   # Height of the application window
SCREEN_TITLE = "Gosu GUI MUSIC PLAYER"                # Title of the application window
SCREEN_FPS = 60                                       # Desired frames per second for the application
SCREEN_SCALE \\file.txt= 2                                      # Scaling factor for the screen
SCREEN_SCALE_X = SCREEN_WIDTH / SCREEN_SCALE          # Scaled width of the screen


#To avoid repetition

#x-axis position of track name displayed
TR_XLOC = 500 
module ZOrder
  BACKGROUND, PLAYER, UI = *0..2                                  # Define the drawing order for different elements
end


GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']          # Define names for different music genres

module Genre
	POP, CLASSIC, JAZZ, ROCK = *1..4                                # Define constants for different music genres
end




class ArtWork
	attr_accessor :bmp, :dimension                                                           # Define attributes for artwork

	def initialize(file, xLeft, yUp)
		@bmp = Gosu::Image.new(file)                                                         # Load the artwork image
		@dimension = Dimension.new(xLeft, yUp, xLeft + @bmp.width(), yUp + @bmp.height())    # Define the dimension of the artwork  
	end
end

# Album Class
class Album
	attr_accessor :title, :artist, :artwork, :tracks              # Define attributes for an album
	def initialize(title, artist, artwork, tracks)
		@title = title         # Set the title of the album
		@artist = artist       # Set the artist of the album
		@artwork = artwork     # Set the artwork of the album
		@tracks = tracks       # Set the tracks of the album
	end
end

#Track Class
class Track
	attr_accessor :name, :location, :dimension # Define attributes for a track
	def initialize(name,location,dimension)
		@name = name                          # Set the name of the track
		@location = location                  # Set the location of the track file
		@dimension = dimension                # Set the dimension of the track
	end
end

#Dimension Class
class Dimension
	attr_accessor :xLeft, :yUp, :xRight, :yBottom          # Define attributes for dimensions
	def initialize (xLeft, yUp, xRight, yBottom)
		@xLeft = xLeft       # Set the left position
		@yUp = yUp           # Set the top position
		@xRight = xRight     # Set the right position
		@yBottom = yBottom   # Set the bottom position
	end
end

class MusicPlayerMain < Gosu::Window

	def initialize
	    super SCREEN_WIDTH,SCREEN_HEIGHT   # Initialize the window with the specified width and height
	    self.caption = "Music Player"      # Set the window caption
		@track_font = Gosu::Font.new(25)   # Create a font for track names
		@albums = read_albums()            # Read the albums from a file and store them in an array
		@album_playing = -1     # Initialize the currently playing album index to -1
		@track_playing = -1     # Initialize the currently playing track index to -1
	end

# Reads a single track from the file and creates a Track object

  def read_track(a_file, index)
	track_name = a_file.gets.chomp
	track_location = a_file.gets.chomp

# Calculate the dimensions of the track

	xLeft = TR_XLOC
	yUp = 50 * index + 30
	xRight = xLeft + @track_font.text_width(track_name)
	yBottom = yUp + @track_font.height()
	dimension = Dimension.new(xLeft, yUp, xRight, yBottom)

	track = Track.new(track_name, track_location,dimension)
	return track
  end

# Reads multiple tracks from the file and returns an array of Track objects

  def read_tracks(a_file)
	count = a_file.gets.chomp.to_i
	tracks = Array.new()
	i = 0
	while i < count
		track = read_track(a_file, i)
		tracks << track
		i +=1
	end
	return tracks
  end

# Reads an album from the file and creates an Album object

	def read_album(a_file, index)
		title = a_file.gets.chomp
		artist = a_file.gets.chomp
		
#Dimension of Album's Artwork

		if index % 2 == 0
			xLeft = 30
		else #seperates the picture on the x-axis
			xLeft = 250
		end
		yUp = 190 * (index / 2) + 30 + 20 * (index / 2) #seperate the picture on the y-axis

		artwork = ArtWork.new(a_file.gets.chomp, xLeft, yUp)
		tracks = read_tracks(a_file)
		album = Album.new(title, artist, artwork, tracks)
		return album
	end

# Reads albums from the file and returns an array of Album objects

	def read_albums()
		a_file = File.new("file.txt", "r")
		i = 0
		count = a_file.gets.chomp.to_i()
		albums = Array.new()
		while i<count
			album = read_album(a_file,i)
			albums << album
			i += 1
		end
		a_file.close()
		return albums
	end

# Draws the track list for a selected album
	def draw_tracks(album)
		album.tracks.each do |track|
			show_track(track)
		end
  	end
# Draws the album artwork images on the screen

  	def draw_albums(albums)
		albums.each do |album|
			album.artwork.bmp.draw(album.artwork.dimension.xLeft, album.artwork.dimension.yUp , z = ZOrder::PLAYER)
		end
	end


#Draws the indicator of the song currently being played

	def draw_current_playing(index, album)
		draw_rect(album.tracks[index].dimension.xLeft - 10, album.tracks[index].dimension.yUp, 5, @track_font.height(), Gosu::Color::WHITE, z = ZOrder::PLAYER)
	end


# Checks if a specific area on the screen is clicked

  def area_clicked(xLeft, yUp, xRight, yBottom)
     if mouse_x > xLeft && mouse_x < xRight && mouse_y > yUp && mouse_y < yBottom
	 	return true
	 end
	 return false
  end


# Draws the name of a track on the screen

  def show_track(track)
  	@track_font.draw(track.name, TR_XLOC, track.dimension.yUp, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::WHITE)
  end


# Plays a specific track from an album

  def play_Track(track, album)
  			@song = Gosu::Song.new(album.tracks[track].location)
  			@song.play(false)
  end

# Draws a colored background on the screen

	def draw_background
		draw_quad(0,0, TOP_COLOR, 0, SCREEN_HEIGHT, TOP_COLOR, SCREEN_WIDTH, 0, BOTTOM_COLOR, SCREEN_WIDTH, SCREEN_HEIGHT, BOTTOM_COLOR, z = ZOrder::BACKGROUND)
	end

# Draws the user interface

	def draw
		draw_background()
		draw_albums(@albums)

#Displays the selected album's tracks if it's selected

		if @album_playing >= 0
			draw_tracks(@albums[@album_playing])
			draw_current_playing(@track_playing, @albums[@album_playing])
		end

# Draw the "Current Playing" text

		current_song = @album_playing >= 0 ? @albums[@album_playing].tracks[@track_playing].name : " "
		current_playing_text = "Playing: #{current_song}"

		text_width = @track_font.text_width(current_playing_text)
		text_x = (SCREEN_WIDTH - text_width) / 2
		text_y = SCREEN_HEIGHT - 80

		@track_font.draw(current_playing_text, text_x, text_y, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)

	end

# handles the update

    def update
		#Plays first song of album if an album has been selected and no other album was selected before
		if @album_playing >= 0 && @song == nil
			@track_playing = 0
			play_Track(0, @albums[@album_playing])
		end
		#Plays an album if it's selected
        if @album_playing >= 0 && @song != nil && (not @song.playing?)
                @track_playing = (@track_playing + 1) % @albums[@album_playing].tracks.length()
                play_Track(@track_playing, @albums[@album_playing])
        end
end

# Indicates whether the game window requires a cursor

	def needs_cursor?
		true
	end

# Handles button presses

	def button_down(id)
		case id
	    when Gosu::MsLeft
		#Checks whether an album is selected or not
			if @album_playing >= 0
	    		#Checks which track is clicked 
				for i in 0..@albums[@album_playing].tracks.length() - 1
					if area_clicked(@albums[@album_playing].tracks[i].dimension.xLeft, @albums[@album_playing].tracks[i].dimension.yUp, @albums[@album_playing].tracks[i].dimension.xRight, @albums[@album_playing].tracks[i].dimension.yBottom)
						play_Track(i, @albums[@album_playing])
		    			@track_playing = i
						break
					end
	    		end
			end
				#Checks which album is selected
			for i in 0..@albums.length() - 1
				if area_clicked(@albums[i].artwork.dimension.xLeft, @albums[i].artwork.dimension.yUp, @albums[i].artwork.dimension.xRight, @albums[i].artwork.dimension.yBottom)
					@album_playing = i
					@song = nil
					break
				end
			end
		end
		end
	end

# Main entry point of the program


MusicPlayerMain.new.show if __FILE__ == $0
