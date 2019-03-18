#!/usr/bin/env ruby

def simulate(strategy, verbose)
  # Prepare three doors and randomize goats and cars
  doors = ['goat', 'goat', 'car'].shuffle

  # Player selects a random door
  player_selected_door = rand(0..2)

  # Time for Monty to open one of the doors:
  doors_goat_indices = doors.each_index.select{|i| doors[i] == 'goat'}
  if doors[player_selected_door] == 'car'
    # If the player picked the door with the car,
    # then Monty opens one of the other two doors
    monty_opened_door = doors_goat_indices.sample
  else
    # If the player picked one of the doors with a goat,
    # then Monty opens the other door with a goat
    monty_opened_door = (doors_goat_indices - [player_selected_door]).first
  end

  puts "Doors: #{doors}" if verbose
  puts "Player picked door #{player_selected_door} (#{doors[player_selected_door]})" if verbose
  puts "Monty opened door #{monty_opened_door} (#{doors[monty_opened_door]})" if verbose

  # Now Monty will give the player the option to switch to the other door
  if strategy == 'switch'
    # The player switches to the other closed door
    player_selected_door = ([0,1,2] - [player_selected_door, monty_opened_door]).first
    puts "Player switched to door #{player_selected_door} (#{doors[player_selected_door]})" if verbose
  end

  player_won = (doors[player_selected_door] == 'car')
  puts "Player #{player_won ? 'won' : 'lost'}" if verbose
  return player_won
end


# Simulation settings
num_sims = ARGV[0].to_i # How many times to run the simulation
num_sims = 1 if num_sims.zero?
strategy = ARGV[1] # 'switch' or 'stay'
strategy = 'stay' unless strategy == 'switch'
verbose = false # Whether to print the events of each simulation

# Run simulations
win_count = 0
num_sims.times {
  win_count += 1 if simulate(strategy, verbose)
}

# Print results
puts "Ran #{num_sims} simulations with strategy '#{strategy}'"
puts "The player won #{win_count} times (#{100 / num_sims * win_count}% win rate)"
