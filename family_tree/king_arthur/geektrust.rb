# frozen_string_literal: true

require 'pry'
require './constants'
require './models/member'
require './seeds'

def main
  operation = ARGV[0]
  total_args = ARGV.count
  result = case operation
           when Commands::ADD_CHILD
             # ADD_CHILD Flora Victoria Female
             return Message::INSUFFICIENT_PARAMS if args_not_satisfied?(total_args, 4)

             parent = Member.find(name: ARGV[1])

             return Message::PERSON_NOT_FOUND if parent.empty?

             args = { name: ARGV[2], gender: ARGV[3] }
             parent.send(Commands::ADD_CHILD.to_s.downcase, args)
           when Commands::GET_RELATIONSHIP
             # GET_RELATIONSHIP Flora Daughter
             return Message::INSUFFICIENT_PARAMS if args_not_satisfied?(total_args, 2)

             Member.send(Commands::GET_RELATIONSHIP.to_s.downcase, ARGV[1], ARGV[2])
           when Commands::ADD_SPOUSE
             # ADD_SPOUSE Bill Flora Female
             return Message::INSUFFICIENT_PARAMS if args_not_satisfied?(total_args, 4)

             parent = Member.find(name: ARGV[1])

             return Message::PERSON_NOT_FOUND if parent.empty?

             Member.send(Commands::ADD_SPOUSE.to_s.downcase, ARGV[1], ARGV[2])
           else
             return Message::INVALID_COMMAND
           end
  p result
end

def args_not_satisfied?(args, min_arg_count)
  args < min_arg_count
end

main
