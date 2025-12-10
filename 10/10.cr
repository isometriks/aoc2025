input = File.read("input.txt").chomp.split("\n").
  map do |s|
    config =  s.match(/\[(.*)\]/)
    config = config ? config[1] : "."
    buttons = s.scan(/\((.*?)\)/).map { |m| m[1].split(",").map(&.to_i) }
    joltages = (s.match(/\{(.*?)\}/) || [""])[1].split(",").map(&.to_i)

    i = -1
    config_int = config.split("").reduce(0) do |acc, c|
      i += 1
      if c == "#"
        acc + 2 ** i
      else
        acc
      end
    end

    button_ints = buttons.map do |button|
      button.reduce(0) do |acc, n|
        acc + 2 ** n
      end
    end

    {
      config_int,
      button_ints,
      buttons,
      joltages
    }
  end

def check_lights(button, buttons, value, expected, iterations = 0, history = [] of Int32, minimum = 100000)
  history = history.dup << button
  value = value ^ button

  if history.size > 12 || history.size >= minimum
    return {10000, history}
  end

  if value == expected
    return {iterations, history}
  end

  min = buttons.select { |b| button != b }.map do |other|
    answer = check_lights(other, buttons, value, expected, iterations + 1, history, minimum: minimum)
    minimum = [minimum, answer[1].size].min
    answer
  end.min_by { |m| m[1].size }

  {iterations + min[0], min[1]}
end

def lights(input)
  i = 0
  total = input.map do |config|
    puts "Working through #{i} of #{input.size}"
    expected, buttons = config
    minimum_so_far = 100000

    answers = buttons.map do |button|
      answer = check_lights(button, buttons, 0, expected, minimum: minimum_so_far)
      minimum_so_far = answer[1].size

      answer
    end

    answer = answers.min_by { |a| a[1].size }

    if answer[0] >= 10000
      raise "We hit the limit dude"
    end

    i += 1

    answer[1].size
  end.sum
end

#puts "Part 1 : #{lights(input)}"

def joltage_value(value, button)
  value = value.clone

  button.each do |n|
    value[n] += 1
  end

  value
end

def joltage_overflow?(value, expected)
  (0...expected.size).each do |n|
    if value[n] > expected[n]
      return true
    end
  end

  false
end

def check_joltages_max(button, value, expected, history = [] of Array(Int32)) #, expected, history = [] of Array(Int32))
  max_button = 0
  history = history.dup
  chain = [] of Tuple(Array(Int32), Array(Array(Int32)))

  loop do
    new_value = joltage_value(value, button)

    if joltage_overflow?(new_value, expected)
      break
    else
      history << button
      value = new_value

      chain << {value, history}
    end
  end

  chain
end

def check_joltage_subpaths(buttons, value, expected, history = [] of Array(Int32), root = false)
  buttons.each_with_index do |button, i|
    puts "Checking button #{i}" if root
    chain = check_joltages_max(button, value, expected, history)

    if chain.size == 0
      next
    end

    #puts "Chain is #{chain[-1].inspect}"

    if chain.last[0] == expected
      raise "We got it bois: #{history}"
    end

    #puts "Checking if #{chain.last[1].last} == #{button} ?? #{chain.last[1].last == button} chain size is #{chain.size}"
    while chain.size > 0 && chain.last[1].last == button
      #puts ">> CHEKING INSIDE LOOPY"
      check_joltage_subpaths(buttons[i..], chain.last[0], expected, chain.last[1])

      #puts "#{chain.last[0]} ==? #{expected}"
      if chain.last[0] == expected
        raise "We got it bois: #{history}"
      end

      chain = chain[...-1]
    end
  end
end

def check_joltages(button, buttons, value, expected, iterations = 0, history = [] of Array(Int32), minimum = 100000, max_history = 2)
  history = history.dup << button
  value = joltage_value(value, button)

  max_button = check_joltages_max(button, value, expected)
  puts "Max button of #{button} is #{max_button}"
  exit

  if history.size > max_history || history.size >= minimum
    return {:exit, history}
  end

  return {:exit, history} if joltage_overflow?(value, expected)

  #puts "Didn't return checking if #{value} > #{expected} for some reason"
  #puts history

  if value == expected
    return {history.size, history}
  end

  min = buttons.map do |other|
    answer = check_joltages(other, buttons, value, expected, iterations + 1, history, minimum: minimum, max_history: max_history)
    minimum = [minimum, answer[1].size].min if answer[0] != :exit
    answer
  end

  min = min.select { |m| m[0] != :exit }

  if min.size == 0
    return {:exit, [] of Array(Int32)}
  end

  min = min.min_by { |m| m[1].size }

  {:continue, min[1]}
end

def joltages(input)
  i = 0
  total = input.map do |config|
    _, _, buttons, expected = config
    puts "Working through #{i} of #{input.size} with buttson #{buttons} and we need #{expected}"
    minimum_so_far = 10000000
    answers = [] of Tuple(Symbol, Array(Array(Int32)))

    check_joltage_subpaths(buttons, Array.new(expected.size, 0), expected, root: true)

    (0..100).each do |max_history|
      b = 0
      answers = buttons.map do |button|
        b += 1
        puts ">> Working on button #{b} of #{buttons.size} with max_history: #{max_history}"
        answer = check_joltages(button, buttons, Array.new(expected.size, 0), expected, minimum: minimum_so_far, max_history: max_history)
        minimum_so_far = answer[1].size if answer[0] != :exit

        answer
      end

      answers = answers.select { |a| a[0] != :exit }

      if answers.size > 0
        puts "Breaking with #{answers.inspect}"
        break
      end
    end

    puts answers

    if answers.size == 0
      puts
      raise "We hit the limit dude"
    end

    puts "Got answers: #{answers.inspect}"

    answer = answers.min_by { |a| a[1].size }
    i += 1

    answer[1].size
  end.sum
end

puts "Part 2: #{joltages(input)}"

