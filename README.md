# Rales-Engine
[Project Spec](http://backend.turing.io/module3/projects/rails_engine "Project Spec")

Rales-Engine is a JSON API built with Ruby, Rails and Activerecord. It’s purpose is to expose SalesEngine data schema.

9/3/2018: Implement API Documentation & Swagger UI


<img alt="swagger-screen" src="https://cl.ly/6cd161ada2a2/Screen%20Shot%202018-09-03%20at%207.58.31%20PM.jpg">


### Accessing Rales-Engine
```
git clone git@github.com:emmiehayes/rales_engine.git
cd rales_engine
bundle update
rake db:{drop,create,migrate}
rake import:all
rails s
visit localhost:3000 from the command line for Swagger UI interface
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
