require 'rubygems'
require 'gosu'

# Window dimensions

WIDTH = 359
HEIGHT = 639

# Gravity constant

GRAVITY = 1200

module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

class Bird
  attr_accessor :img, :vel, :pos

  def initialize
    @img = Gosu::Image.new("images/bird.png")         # Load the bird image
    @vel = 0                                          # Bird's vertical velocity
    @pos = 300                                        # Bird's position on the screen
  end
end

class Obstacle
  attr_accessor :x, :y_up, :y_down, :img

  def initialize
    @x = 359                                         # Starting position of the obstacle
    if rand(0..1000) > 499
      @y_up = rand(-379..-350)                       # Random upper obstacle position 
      @y_down = rand(220..250)                       # Random lower obstacle position
    else
      @y_up = rand(-150..-120)                       # Random upper obstacle position
      @y_down = rand(480..510)                       # Random lower obstacle position
    end
    @img = Gosu::Image.new("images/obstacle.png")    # Load the obstacle image
  end
end

class Sunfeastbounce < Gosu::Window
  def initialize
    super WIDTH, HEIGHT
    self.caption = "Bouncy Bird"

    # Load images and initialize game variables

    @background = Gosu::Image.new("images/background.png")  # Load the background image
    @bird = Bird.new                                        # Create a new bird object
    @obstacles = []                                         # Array to store obstacles
    @timer = 80                                             # Timer for spawning obstacles
    @score = -1                                             # Game score (initially set to -1)
    @font = Gosu::Font.new(20)                              # Font for drawing text
    @font1 = Gosu::Font.new(50)                             # Font for drawing title text
    @status = :home                                         # Game status (default to home screen)
    @high_scores = []                                       # Array to store high scores
    load_high_scores                                        # Load high scores from file
  end

  def update
    case @status
    when :game
      update_game
    end
  end

  def update_game
    update_bird
    update_obstacles
    check_collisions
    update_score_timer
  end

  def update_bird

    # Update bird's position and velocity based on gravity

    @bird.vel += GRAVITY * (update_interval / 1000)
    @bird.pos += @bird.vel * (update_interval / 1000)
  end

  def update_obstacles

    # Move obstacles to the left and spawn new ones

    @obstacles.each { |obstacle| obstacle.x -= 5 }
    spawn_obstacle if @timer.zero?
  end

  def check_collisions

    # Check if the bird collides with any obstacles

    @obstacles.each do |obstacle|
      if bird_hits_obstacle?(obstacle)
        game_over
        return
      end
    end

    # Check if the bird is out of bounds

    game_over if bird_out_of_bounds?
  end

  def update_score_timer

    # Update score and reset timer

    @timer -= 1
    @score += 1 if @timer.zero?
    @timer = 80 if @timer.negative?
  end

  def draw
    case @status
    when :game
      draw_game
    when :home
      draw_home
    when :game_over
      draw_game_over
    when :high_scores
      draw_high_scores
    end
  end

  def button_down(id)
    case @status
    when :game
      handle_game_button_down(id)
    when :home
      handle_home_button_down(id)
    when :game_over
      handle_game_over_button_down(id)
    when :high_scores
      handle_high_scores_button_down(id)
    end
  end

  def handle_game_button_down(id)

    # Handle button presses during the game

    close if id == Gosu::KbEscape
    flap_bird if id == Gosu::KbSpace
  end

  def handle_home_button_down(id)

    # Start the game or show high scores

    case id
    when Gosu::KbSpace
      start_game
    when Gosu::KbH
      show_high_scores
    end
  end

  def handle_game_over_button_down(id)

    # Restart the game or show high scores

    case id
    when Gosu::KbSpace
      start_game
    when Gosu::KbH
      show_high_scores
    end
  end

  def handle_high_scores_button_down(id)

    # Go back to the home screen

    show_home if id == Gosu::KbSpace
  end

  def spawn_obstacle

    # Create a new obstacle and add it to the list

    obstacle = Obstacle.new
    @obstacles << obstacle
  end

  def bird_hits_obstacle?(obstacle)

    # Check if the bird collides with a given obstacle

    bird_right = @bird.pos + @bird.img.height
    bird_bottom = @bird.pos + @bird.img.height

    if obstacle.x < @bird.img.width + 20 && obstacle.x + obstacle.img.width > 20
      if @bird.pos < obstacle.y_up + obstacle.img.height || bird_bottom > obstacle.y_down
        return true
      end
    end

    false
  end

  def bird_out_of_bounds?

    # Check if the bird is out of the window bounds

    @bird.pos > HEIGHT || @bird.pos + @bird.img.height < 0
  end

  def start_game

    # Reset game variables and start the game

    @status = :game
    @bird = Bird.new
    @obstacles = []
    @timer = 80
    @score = -1
  end

  def show_home

    # Go back to the home screen

    @status = :home
  end

  def show_high_scores

    # Show the high scores screen

    @status = :high_scores
  end

  def draw_game

    # Draw game elements: background, bird, score, obstacles

    @background.draw(0, 0, ZOrder::BACKGROUND)
    draw_bird
    draw_score if @score.positive?
    draw_obstacles
  end

  def draw_home

    # Draw the home screen with title and instructions

    @background.draw(0, 0, ZOrder::BACKGROUND)
    @font1.draw("Welcome!", 80, HEIGHT / 2 - 50, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
    @font.draw("Press SPACE to start", 100, HEIGHT / 2, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
    @font.draw("Press H for high scores", 100, HEIGHT / 2 + 30, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
  end

  def draw_game_over

    # Draw the game over screen with end message and instructions

    @background.draw(0, 0, ZOrder::BACKGROUND)
    @font1.draw("Game Over", 80, HEIGHT / 2 - 50, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
    @font.draw("Press SPACE to restart", 100, HEIGHT / 2, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
    @font.draw("Press H for high scores", 100, HEIGHT / 2 + 30, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
  end

  def draw_high_scores

    # Draw the high scores screen with the list of high scores

    @background.draw(0, 0, ZOrder::BACKGROUND)
    @font1.draw("High Scores", 80, 50, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLUE)

    @high_scores.each_with_index do |score, index|
      y = 100 + index * 30
      @font.draw("#{index + 1}. #{score}", 100, y, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
    end

    @font.draw("Press SPACE to go back", 80, HEIGHT - 100, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
  end

  def draw_bird
    @bird.img.draw(20, @bird.pos, ZOrder::PLAYER)
  end

  def draw_score
    @font.draw("Score: #{@score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
  end

  def draw_obstacles
    @obstacles.each do |obstacle|
      obstacle.img.draw(obstacle.x, obstacle.y_up, ZOrder::PLAYER)
      obstacle.img.draw(obstacle.x, obstacle.y_down, ZOrder::PLAYER)
    end
  end

  def flap_bird

    # Make the bird jump when the space key is pressed

    @bird.vel = -350
  end

  def game_over

    # Game over, update high scores and change game status

    update_high_scores
    @status = :game_over
  end

  def update_high_scores

    # Add current score to high scores and sort the list

    @high_scores << @score
    @high_scores.sort! { |a, b| b <=> a }
    @high_scores = @high_scores.first(5) if @high_scores.size > 5
    save_high_scores
  end

  def load_high_scores

    # Load high scores from a file

    if File.exist?("high_scores.txt")
      @high_scores = File.readlines("high_scores.txt").map(&:to_i)
    end
  end

  def save_high_scores

    # Save high scores to a file

    File.open("high_scores.txt", "w") do |file|
      @high_scores.each { |score| file.puts score }
    end
  end
end

# Run the game
Sunfeastbounce.new.show if __FILE__ == $0
