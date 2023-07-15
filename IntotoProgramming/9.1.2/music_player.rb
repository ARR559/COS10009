require './input_functions'


# Use the code from last week's tasks to complete this:
# eg: 6.2, 3.1T

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

#class album created

class Album
# NB: you will need to add tracks to the following and the initialize()
	attr_accessor :title, :artist, :year, :genre,:tracks 

# complete the missing code:
#initialize method to get the variables from object

	def initialize (title, artist,year, genre,tracks)
		@title=title
		@artist=artist
		@year=year
		# insert lines here
		@genre = genre
		@tracks=tracks
	end
end

#class track created

class Track
attr_accessor :name, :location

# initialize method to get the name and location from the object
  def initialize (name, location)
    @name = name
    @location = location
  end
end

#To read the file and while loop is used to iterate the files from albums

def read_albums(music_file)
  file_name=File.new(music_file,"r")
  count = file_name.gets().to_i
  index=0
  albums = Array.new()
  while(index<count)
    album = read_album(file_name) 
    albums << album 
    index+=1
  end

#it will also print the total no of albums loaded from file and returns albums

  read_string(albums.length.to_s+" albums loaded. Press enter to continue")
  file_name.close
  return albums
end
def print_tracks(tracks)
  i=0
  while i<tracks.length
      print_track(tracks[i],i)
      i+=1
  end

# print all the tracks use: tracks[x] to access each track.

end
def print_track(track,i)
  a=i+1
  puts(a.to_s+"."+track.name)
	puts(track.location)
end
def read_album(music_file)

# read in all the Album's fields/attributes including all the tracks
# complete the missing code

  album_artist=music_file.gets()
	album_title=music_file.gets()
  album_year=music_file.gets().to_i
	album_genre=music_file.gets().to_i
	tracks=read_tracks(music_file)
	album = Album.new(album_title, album_artist, album_year, album_genre, tracks)
	return album
end

# it will read all the tracks from the musicfile provided

def read_tracks(music_file)
	
	count = music_file.gets().to_i()
  tracks = Array.new()

# Put a while loop here which increments an index to read the tracks

  index=0
	while index<count
  	    track = read_track(music_file)
  	    tracks << track
		    index+=1
	end	

	return tracks
end

#it will read a single track from the music File

def read_track(music_file)
  track_name = music_file.gets().chomp
  track_location = music_file.gets().chomp
  Track.new(track_name, track_location)
end

# I created a menu here to display all the albums according to the users choice
# options for the user to see the albums

def display_albums(albums)
  finished = false
  begin
    puts("Display Album Menu:")
    puts("1.Display all Albums")
    puts("2.Display Albums by Genre")
    puts("3.Back to Main Menu")

#gets input from user and if matches the choice, it will run that particular function

    choice = read_integer_in_range("Please enter your choice:", 1, 3)
    case choice
    when 1
      print_albums(albums) 
    when 2
      display_all_genre(albums)
    when 3
      finished = true
    else
      puts('Please select again')
    end
  end until finished
end

# Gets total length of albums and print selected album

def print_albums(albums)
    e=0
    while e<albums.length
          print_album(albums[e],e)
          e+=1
    end
end    
def print_album(album,f)

# print out all the albums fields/attributes
# Complete the missing code.

  i=f+1
  puts(i.to_s+'.'+'Title: '+album.title+' Artist: '+album.artist+' Genre: '+$genre_names[album.genre])
#puts(album.title)
#puts('Genre is ' + album.genre.to_s)
#puts($genre_names[album.genre])
#print_tracks(album.tracks)
# print out the tracks

end      

# display all albums by Genre
# it gets the user input and displays that individual album as per the selection

def display_all_genre(albums)
    puts("1." + $genre_names[1])
    puts("2." + $genre_names[2])
    puts("3." + $genre_names[3])
    puts("4." + $genre_names[4])
    choice = read_integer_in_range("Please enter your choice:", 1, 4)
    case choice
    when 1
      genre_names = 1
      genre_albums(albums, genre_names)
    when 2
      genre_names = 2
      genre_albums(albums, genre_names)
    when 3
      genre_names = 3
      genre_albums(albums, genre_names)
    when 4
      genre_names = 4
      genre_albums(albums, genre_names)
    else
      puts('Please select again')
    end
  
end

# this function is printing albums according to the genre

def genre_albums(albums, genre_names)
    i=0
    a=0
    while i<albums.length
          if albums[i].genre.to_i==genre_names
             print_album(albums[i],a)
             a+=1
          end
          i+=1
    end      
end

# this function gets the album number from user and prints the single album which user chose
def play_tracks(albums)
    count=albums.length
    id=read_integer_in_range("Enter album number: ",1,count)
    album=albums[id-1]
    trackc=album.tracks.length
    if trackc>0
       print_tracks(album.tracks)
       t_id=read_integer_in_range("Select a Track to play: ",1,trackc)
       puts"Playing track #{albums[id-1].tracks[t_id-1].name} from album #{album.title}"
    end   

end

# this album calls the print_albums and play_tracks album

def play_albums(albums)
    print_albums(albums)
    play_tracks(albums)
    
end

# It gets the file path from user to load the File

def File_path()
  file_path=read_string("Enter a file path to an Album:")
	music_file=File.new(file_path,"r")
	albums=Array.new()
	count=music_file.gets.chomp.to_i
	#read_string(count.to_s+" albums are loaded. Press enter to continue.")
  albums=read_albums(music_file)
  return albums
end	

# gets the new title from the users

def update_title(album)
    new_title=read_string("Enter a new title for the Album")
    album.title=new_title
end   

# gets the genre and updates the genre in that particular Album

def update_genre(album)
    new_genre=read_integer_in_range("1.Pop\n2.Classic\n3.Jazz\n4.Rock\nEnter number of Genre:",1,4) 
    album.genre=new_genre
end    

#This method updates the title and genre 
#Prints the updated title and genre to the terminal

def update_album(albums)
    count=albums.length
    print_albums(albums)
    id=read_integer_in_range("Enter the album to edit:",1,count)
    album=albums[id-1]
    puts('1. Update Title')
    puts('2. Update Genre')
    choice=read_integer_in_range("Enter selection:",1,2)
    case choice
    when 1
      album.title=update_title(album)
    when 2
      album.genre=update_genre(album)  
    end  
    puts('Title: '+album.title+' Genre: '+$genre_names[album.genre])
    read_string("Press enter to continue")  
    
end

# This method calls the main menu for the user
# User has 5 options to choose from which is performed by each function called 

def main()
  finished = false
  albums=[]
  begin
    puts('1. Read in Albums')
    puts('2. Display Albums')
    puts('3. Select an Album to play')
    puts('4. Update an existing Album')
    puts('5. Exit the application')
    choice = read_integer_in_range("Please enter your choice:", 1, 5)
    case choice
	  when 1
	    albums=File_path()
    when 2
      display_albums(albums) 
    when 3
      play_albums(albums)
	when 4
	   update_album(albums)
    when 5
      finished = true
    else
      puts('Please select again')
    end
  end until finished
end
main()

