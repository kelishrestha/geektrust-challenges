require 'pry'
require './constants'
require './models/house'

def main
  input_file = ARGV[1]
  # parse the file and process the command
  unparsed_commands = File.read input_file
  parsed_commands = unparsed_commands.split("\n")
  parsed_commands.each do |command|
    arguments = command.split(' ')
    operation = arguments[0]
    total_args = arguments.count - 1
    result = case operation
              when Commands::MOVE_IN
                return Message::INSUFFICIENT_PARAMS if args_not_satisfied?(total_args, 1)
                args = { member: arguments[1] }
                House.add_members(args)
              when Commands::MOVE_OUT
              when Commands::CLEAR_DUE
              when Commands::SPEND
              when Commands::DUES
              else
                p Message::INVALID_COMMAND
              end
      # print the output
      p result
  end
end

def args_not_satisfied?(args, min_arg_count)
  args < min_arg_count
end
