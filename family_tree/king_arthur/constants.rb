# frozen_string_literal: true

module Relation
  PATERNAL_UNCLE = 'PATERNAL_UNCLE'
  MATERNAL_UNCLE = 'MATERNAL_UNCLE'
  PATERNAL_AUNT = 'PATERNAL_AUNT'
  MATERNAL_AUNT = 'MATERNAL_AUNT'
  SISTER_IN_LAW = 'SISTER_IN_LAW'
  BROTHER_IN_LAW = 'BROTHER_IN_LAW'
  SON = 'SON'
  SONS = 'SON'
  DAUGHTER = 'DAUGHTER'
  DAUGHTERS = 'DAUGHTER'
  SIBLINGS = 'SIBLINGS'
end

module Message
  CHILD_ADDITION_SUCCEEDED = 'CHILD_ADDITION_SUCCEEDED'
  SPOUSE_ADDITION_SUCCEEDED = 'SPOUSE_ADDITION_SUCCEEDED'
  PERSON_NOT_FOUND = 'PERSON_NOT_FOUND'
  CHILD_NOT_FOUND = 'CHILD_NOT_FOUND'
  NONE = 'NONE'
  CHILD_ADDITION_FAILED = 'CHILD_ADDITION_FAILED'
  INVALID_RELATION = 'INVALID_RELATION'
  INVALID_COMMAND = 'INVALID_COMMAND!'
  NOT_IMPLEMENTED = 'NOT_IMPLEMENTED'
  INSUFFICIENT_PARAMS = 'INSUFFICIENT_PARAMS'
end

module Commands
  GET_RELATIONSHIP = 'GET_RELATIONSHIP'
  ADD_CHILD = 'ADD_CHILD'
  ADD_FAMILY_HEAD = 'ADD_FAMILY_HEAD'
  ADD_SPOUSE = 'ADD_SPOUSE'
end
