# Complete the following
def factorial(a)
  if a == 0
    return 1
  else
    return a * factorial(a-1)
  end
end

# Add to the following code to prevent errors for ARGV[0] < 1 and ARGV.length < 1
def main
  if ARGV.length < 1
    puts "Incorrect argument - need a single argument with a value of 0 or more.\n"
  elsif ARGV[0].to_i < 0
    puts "Incorrect argument - need a single argument with a value of 0 or more.\n"
  else
    puts factorial(ARGV[0].to_i)
  end
end

main
