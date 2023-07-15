require './input_functions'

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..5
end

$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock', 'hiphop']

class Album
	attr_accessor :title, :artist, :year, :genre,:tracks 

	def initialize (title, artist,year, genre,tracks)
		@title=title
		@artist=artist
		@year=year
		@genre = genre
		@tracks=tracks
	end
end


class Track
attr_accessor :name, :location

  def initialize (name, location)
    @name = name
    @location = location
  end
end

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
end
def print_track(track,i)
  a=i+1
  puts(a.to_s+"."+track.name)
	puts(track.location)
end

def read_album(music_file)
  album_artist=music_file.gets()
	album_title=music_file.gets()
  album_year=music_file.gets().to_i
	album_genre=music_file.gets().to_i
	tracks=read_tracks(music_file)
	album = Album.new(album_title, album_artist, album_year, album_genre, tracks)
	return album
end

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

def read_track(music_file)
  track_name = music_file.gets().chomp
  track_location = music_file.gets().chomp
  Track.new(track_name, track_location)
end

def display_albums(albums)
  finished = false
  begin
    puts("Display Album Menu:")
    puts("1.Display all Albums")
    puts("2.Display Albums by Genre")
    puts("3.Back to Main Menu")
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
def print_albums(albums)
    a=0
    while a<albums.length
          print_album(albums[a],a)
          a+=1
    end
end  

def print_album(album,a)
  i=a+1
  puts(i.to_s+'.'+'Title: '+album.title+' Artist: '+album.artist+' Genre: '+ $genre_names[album.genre])
end      

def display_all_genre(albums)
  i = 1
  while i < $genre_names.length
    puts "#{i}. #{$genre_names[i]}"
    i += 1
  end
    choice = read_integer_in_range("Please enter your choice:", 1, $genre_names.length)
    
   while choice != 0
    if (1..$genre_names.length).include?(choice)
      genre_names = choice
      genre_albums(albums, genre_names)
      break
    else
      puts('Please select again')
    end
  end
end
   
   


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

def play_albums(albums)
    print_albums(albums)
    play_tracks(albums)
    
end

def File_path()
  file_path=read_string("Enter a file path to an Album:")
	music_file=File.new(file_path,"r")
	albums=Array.new()
	count=music_file.gets.chomp.to_i
	#read_string(count.to_s+" albums are loaded. Press enter to continue.")
  albums=read_albums(music_file)
  return albums
end	


def main()
  finished = false
  albums=[]
  begin
    puts('1. Read in Albums')
    puts('2. Display Albums')
    puts('3. Select an Album to play')
    puts('5. Exit the application')
    choice = read_integer_in_range("Please enter your choice:", 1, 5)
    case choice
	  when 1
	    albums=File_path()
    when 2
      display_albums(albums) 
    when 3
      play_albums(albums)
    when 5
      finished = true
    else
      puts('Please select again')
    end
  end until finished
end
main()
