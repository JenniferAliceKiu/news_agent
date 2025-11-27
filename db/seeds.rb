require 'faker'

puts "Cleaning database..."
#Chat.destroy_all
Message.destroy_all
Chat.destroy_all
Daily.destroy_all

User.destroy_all


puts "Creating Instances..."
puts 'creating users'
1.times do
  users = User.new(
    email: Faker::Internet.email, #(find or create by)
    password: 'password123'
  )
  users.save!
  end
puts 'Users done'

puts 'creating dailies'
10.times do
  dailies = Daily.new(
    title: Faker::Lorem.sentence(word_count: 5),
    summary: Faker::Lorem.paragraph(sentence_count: 3)
  )
  dailies.save!
  end
puts 'Dailies done'

###

puts 'creating chats'
10.times do
  chats = Chat.new(
    name: Faker::Lorem.words(number: 3).join(' '),
    user: User.last,
    daily: Daily.last
  )
  chats.save!
  end
puts 'Chats done'


puts 'creating messages'
25.times do
  messages = Message.new(
    content: Faker::Lorem.sentence(word_count: 10),
    direction: ['incoming', 'outgoing'].sample,
    chat: Chat.last
  )
  messages.save!
  end
puts 'Messages done'
