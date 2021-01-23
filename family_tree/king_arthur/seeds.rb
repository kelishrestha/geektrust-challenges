# frozen_string_literal: true

require './models/member'

Member.find_or_create_by(name: 'King Arther', gender: 'male', mother: nil, partner: 'Queen Margret')
Member.find_or_create_by({ name: 'Queen Margret', gender: 'female', mother: nil, partner: 'King Arther' })

Member.find_or_create_by({ name: 'Bill', gender: 'male', mother: 'Queen Margret' })
Member.find_or_create_by({ name: 'Flora', gender: 'female', mother: nil, partner: 'Bill' })
Member.create({ name: 'Percy', gender: 'male', mother: 'Queen Margret' })
Member.create({ name: 'Ginerva', gender: 'female', mother: 'Queen Margret' })
Member.create({ name: 'Loius', gender: 'male', mother: 'Flora' })
Member.create({ name: 'Victorie', gender: 'female', mother: 'Flora' })
