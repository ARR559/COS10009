require "./input_functions.rb"

class Track
  attr_accessor :name, :location
  
  def initialize(n, l)
    @name = n
    @location = l
  end
end

def read_track()
  track_name = read_string("Enter track name: ")
  track_location = read_string("Enter track location:")
  track = Track.new(track_name, track_location)
  return track
end

def print_track(track)
  puts "Track name: " + track.name
  puts "Track location: " + track.location
end

def main()
  track = read_track()
  print_track(track)
end

main() if __FILE__ == $0

