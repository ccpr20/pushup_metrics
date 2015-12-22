# Speedrail
Setting up new Rails apps is slow and tedious. Speedrail is a boilerplate template to get started faster. 

Libraries included in this boilerplate rails app:
* User authentication via [Devise](https://github.com/plataformatec/devise)
* Design via [Bootstrap](http://getbootstrap.com) + [Sass](https://github.com/twbs/bootstrap-sass)
* Easy user inputs with [simple_form](https://github.com/plataformatec/simple_form)
* Safely store ENV variables with [Figaro](https://github.com/laserlemon/figaro)
* Responsive toggle navbar w/ logic for login, signup, settings
* Upload-free user avatars with [gravatarify](https://github.com/lwe/gravatarify)
* SEO toolbelt via [metamagic](https://github.com/lassebunk/metamagic)
* Rename your app in 1 command with [Rename](https://github.com/get/Rename)
* Increased debugging power with [Pry](https://github.com/pry/pry) and [Better Errors](https://github.com/charliesome/better_errors)
* Document upload management via [Paperclip](https://github.com/thoughtbot/paperclip) + [S3](https://github.com/aws/aws-sdk-ruby)
* Seed your DB in seconds via [Seed Dump](https://github.com/rroblak/seed_dump)
* Production-ready DB setup via postgres
* Google Analytics with Turbolinks support

## Installation
1. Clone the repo
2. Replace the database names in config/database.yml with your app name
3. Rename your app by running bundle, then rails g rename:app_to name_of_app
4. Run rake db:setup then rake db:migrate to create your new database and the included Users table
5. Uncomment config/application.yml in .gitignore to hide ENV variables from your repo
6. See the top of layout/application.html and pages/home.html to set page titles and descriptions

## Additional Options
1. Configure AWS S3 in config/application.rb
2. New Reg/Sessions controllers override Devise, prepend 'super' to your custom action logic
3. Put your UA-XXX property code for Google Analytics in shared/footer