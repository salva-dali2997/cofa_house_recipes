# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Creates (or updates the password for) your personal account when SEED_USER_EMAIL and
# SEED_USER_PASSWORD are set, e.g.:
#   SEED_USER_EMAIL=you@example.com SEED_USER_PASSWORD=... bin/rails db:seed
if (email = ENV["SEED_USER_EMAIL"]).present? && (password = ENV["SEED_USER_PASSWORD"]).present?
  user = User.find_or_initialize_by(email_address: email)
  user.password = password
  user.password_confirmation = password
  user.save!
  puts "Seeded user #{email}"
end
