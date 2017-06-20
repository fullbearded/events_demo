# Usage

1. clone repo
```
git clone git@github.com:huhongda/events_demo.git

# NOTES: if you don't have ruby 2.3.3, please change the .ruby-version to your ruby version
bundle install
```

2. cp configuartion && modify the database configuartion
```
cp config/database.yml.example config/database.yml
```

3. import data

```
rake db:create
rake db:migrate
rake db:seed
```

4. start server & visit the page
```
rails s
```

visit: http://localhost:3000

