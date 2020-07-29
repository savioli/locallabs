# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Destroy all Stories
Story.destroy_all

# Destroy all Users
User.destroy_all

# Destroy all Chief Editors
ChiefEditor.destroy_all

# Destroy all Writers
Writer.destroy_all

# Destroy all Organizations
Organization.destroy_all


Story.connection.execute('ALTER TABLE stories AUTO_INCREMENT = 1')
Writer.connection.execute('ALTER TABLE users AUTO_INCREMENT = 1')
Organization.connection.execute('ALTER TABLE organizations AUTO_INCREMENT = 1')

# Create an Organization
organization = Organization.create(slug: 'nyn',
                                   name: 'New York News')

# Create a Chief Editor
ChiefEditor.create(name: 'Harvey Chief Editor',
                   email: 'ce@nyn.com',
                   password: 'c',
                   organization: organization)

# Create a Writer
Writer.create(name: 'Mike Writer',
              email: 'w@nyn.com',
              password: 'w',
              organization: organization)

# Create a Writer
Writer.create(name: 'Louis Reviewer',
              email: 'r@nyn.com',
              password: 'r',
              organization: organization)


# Create others Writers
# 15.times do |_index|
#   Writer.create(name: Faker::Name.unique.name,
#                 email: Faker::Internet.email,
#                 password: 'writer',
#                 organization: organization)
# end

# # Create Stories
# 50.times do |_index|
#   Story.create(headline: Faker::Lorem.sentence(6, 0).chop,
#                body: Faker::Lorem.sentence(word_count: 30),
#                status: Random.rand(1..7))
# end
