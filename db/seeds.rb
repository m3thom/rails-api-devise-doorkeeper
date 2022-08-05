# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
client_apps = [
    "Android Client",
    "iOS Client",
    "Web Client",
    "SwaggerDoc Client",
]

client_apps.each do |app_name|
  app = Doorkeeper::Application.find_by(name: app_name)
  if app.blank?
    Doorkeeper::Application.create!(name: app_name, redirect_uri: "", scopes: "")
  end
end

admin_user = User.admin_user

if admin_user.blank?
  User.create!(email: User.admin_user_email, password: 123456)
end
