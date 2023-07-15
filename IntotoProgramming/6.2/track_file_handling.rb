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

  # Put a while loop here which increments an index to read the tracks
  index = 0
  while index<count
    track = read_track(music_file)
    tracks << track
    index = index+1
  end
  return tracks
end

# reads in a single track from the given file.
def read_track(a_file)

track_name = a_file.gets.chomp
track_location = a_file.gets.chomp
track= Track.new(track_name, track_location)

end


# Takes an array of tracks and prints them to the terminal
def print_tracks(tracks)
index=0
while index<tracks.length
puts tracks[index].name
puts tracks[index].location
index=index+1
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

# Open the file and read in the tracks then print them
def main()
  a_file = File.new("input.txt", "r") # open for reading
  tracks = read_tracks(a_file)
  a_file.close()
  # Print all the tracks
  print_tracks(tracks)
  
end

main()
