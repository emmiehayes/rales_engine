# Rales-Engine
[Project Spec](http://backend.turing.io/module3/projects/rails_engine "Project Spec")

Rales-Engine is a JSON API built with Ruby, Rails and Activerecord. It’s purpose is to expose SalesEngine data schema.

### Accessing Rales-Engine
```
git clone git@github.com:sdmalek44/rales_engine.git
cd rales_engine
bundle update
rake db:{drop,create,migrate}
rake import:all
```

### Gems Utilized
- Active_model_serializers
- Byebug
- Database_cleaner
- Factory-Bot
- Faker
- Pry
- Pry-rails
- RSpec-rails
- Shoulda-matchers
- Simplecov

#### Testing
This application utilizes RSpec for testing.  
In order to execute all tests, run the command `rspec` in the terminal.
