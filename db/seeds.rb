# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Destroy all Comments
Comment.destroy_all

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
ChiefEditor.create(name: 'Jessica Pearson',
                   email: 'jessica.pearson@nyn.com',
                   password: 'jessica.pearson',
                   organization: organization)

# Create a Writer
Writer.create(name: 'Mike Ross',
              email: 'mike.ross@nyn.com',
              password: 'mike.ross',
              organization: organization)

# Create a Writer
Writer.create(name: 'Louis Litt',
              email: 'louis.litt@nyn.com',
              password: 'louis.litt',
              organization: organization)

# Create a Writer
Writer.create(name: 'Harvey Specter',
              email: 'harvey.specter@nyn.com',
              password: 'harvey.specter',
              organization: organization)

# Create a Writer
Writer.create(name: 'Katrina Bennett',
              email: 'katrina.bennett@nyn.com',
              password: 'katrina.bennett',
              organization: organization)

# Create a Writer
Writer.create(name: 'Rachel Zane',
              email: 'rachel.zane@nyn.com',
              password: 'rachel.zane',
              organization: organization)