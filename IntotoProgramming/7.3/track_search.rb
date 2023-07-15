require './input_functions'

# Task 6.1 T - use the code from 5.1 to help with this

class Track
	attr_accessor :name, :location

	def initialize (name, location)
		@name = name
		@location = location
	end
end

# Returns an array of tracks read from the given file
def read_tracks(music_file)

  count = music_file.gets().to_i()
  tracks = Array.new()
  index=0
  while index<count
      track=read_track(music_file)
      tracks[index]=track
      index+=1
  end
  # Put a while loop here which increments an index to read the tracks
  #track = read_track(music_file)
  #tracks << track
  return tracks
end

# reads in a single track from the given file.
def read_track(a_file)
  track_name=a_file.gets()
  track_location=a_file.gets()
  track=Track.new(track_name,track_location)
  return track
  # complete this function
	# you need to create a Track here.
end


# Takes an array of tracks and prints them to the terminal
def print_tracks(tracks)
  i=0
  while i<tracks.length
      print_track(tracks[i])
      i+=1
  end    

  # Use a while loop with a control variable index
  # to print each track. Use tracks.length to determine how
  # many times to loop.


  # Print each track use: tracks[index] to get each track record
end

# Takes a single track and prints it to the terminal
def print_track(track)
  puts(track.name)
	puts(track.location)
end

def search_for_track_name(tracks, search_string)
    count=tracks.length
    i = 0
    found_index=-1
    while i < count
        if tracks[i].name.chomp == search_string
            found_index= i
            return found_index
        end
        i = i + 1
    end
    

# Put a while loop here that searches through the tracks
# Use the read_string() function from input_functions.
# NB: you might need to use .chomp to compare the strings correctly

# Put your code here.

  return found_index
end


# Reads in an Album from a file and then prints all the album
# to the terminal

def main()
    a_file = File.new("album.txt", "r") # open for reading
    tracks=read_tracks(a_file)

  # Print all the tracks
    print_tracks(tracks)
  	a_file.close()

  	search_string = read_string("Enter the track name you wish to find: ")
  	index = search_for_track_name(tracks, search_string)
  	if index > -1
   		puts "Found " + tracks[index].name + " at " + index.to_s()
  	else
    	puts "Entry not Found"
  	end
end

main()
