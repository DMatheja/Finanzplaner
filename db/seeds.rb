# This file should contain all the record creation needed to seed the database with its default values.

User.destroy_all

# Create test users
admin = User.create!(
  name: 'Admin User',
  email: 'admin@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: :admin
)

user = User.create!(
  name: 'Test User',
  email: 'user@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: :user
)

viewer = User.create!(
  name: 'Viewer User',
  email: 'viewer@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: :viewer
)

puts "Created 3 test users:"
puts "  Admin: admin@example.com / password123"
puts "  User: user@example.com / password123"
puts "  Viewer: viewer@example.com / password123"
