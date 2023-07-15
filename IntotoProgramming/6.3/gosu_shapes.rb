require 'rubygems'
require 'gosu'
require './circle'

# The screen has layers: Background, middle, top
module ZOrder
  BACKGROUND, MIDDLE, TOP = *0..2
end

class DemoWindow < Gosu::Window
  def initialize
    super(800, 950, false)
  end

  def draw
    # see www.rubydoc.info/github/gosu/gosu/Gosu/Color for colours
    draw_quad(0, 0, 0xff_ffffff, 800, 0, 0xff_ffffff, 0, 950, 0xff_ffffff, 800, 950, 0xff_ffffff, ZOrder::BACKGROUND)
    
    draw_triangle(400, 100, Gosu::Color::RED, 250, 390, Gosu::Color::RED, 550, 400, Gosu::Color::RED, ZOrder::TOP, mode=:default)
    #(200, 200, Gosu::Color::BLACK, 350, 350, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)
    # draw_rect works a bit differently:draw_line
    Gosu.draw_rect(300, 400, 180, 300, Gosu::Color::rgb(127,127,127), ZOrder::TOP, mode=:default)

    # Circle parameter - Radius
    img2 = Gosu::Image.new(Circle.new(450))
    # Image draw parameters - x, y, z, horizontal scale (use for ovals), vertical scale (use for ovals), colour
    # Colour - use Gosu::Image::{Colour name} or .rgb({red},{green},{blue}) or .rgba({alpha}{red},{green},{blue},)
    # Note - alpha is used for transparency.
    # drawn as an elipse (0.5 width:)
    img2.draw(-50, 600, ZOrder::MIDDLE, 1.0, 0.5, Gosu::Color::GREEN)
    # drawn as a red circle:
    #img2.draw(300, 50, ZOrder::TOP, 1.0, 1.0, 0xff_ff0000)
    # drawn as a red circle with transparency:
    #img2.draw(300, 250, ZOrder::TOP, 1.0, 1.0, 0x64_ff0000)

  end
end

DemoWindow.new.show

