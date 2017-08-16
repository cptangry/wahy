# Wahy

Welcome to my Wahy gem repo! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/wahy`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wahy'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wahy

## Usage

```shell
# Just install gem and use wahy command
# For help:
wahy -h

There is the argument's options:
# If you want to see English results you don't need to call -l argument (English is default)
# -l => to pick language ('eng'|'tur') # Default: (English)
# -s => to pick scripture (also can use scripture's number) # between 1-114 # Default: 1
# -a => to pick sign number (also can use all) # Default: all

# User can call only wahy command then will see all sings of first scripture in Engish.

# The Cow Scripture and its all signs
wahy -l 'eng' -s 'The Cow' # alias to: wahy -l 'eng' -s 'The Cow' -a 'all'
wahy -l 'tur' -s 'The Cow' # alias to: wahy -l 'eng' -s 'The Cow' -a 'all'

# The Cow Scripture and its 2nd sign
wahy -l 'eng' -s 'The Cow' -a 2
wahy -l 'tur' -s 'The Cow' -a 2

# Gem includes two XML files 
# English Quran Tranlation(eng.xml): Written by Yusuf Ali
# Turkish Quran Tranlation(tur.xml): Written by Elmalılı Hamdi Yazır
# Special Thanks to: http://www.qurandatabase.org/Database.aspx

# There is a little terminal trick to save output to a file:
wahy -l 'eng' -s 'The Cow' > fileName.txt # :)

# Also in lib directory : wahy.rb is a executable file
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cptangry/wahy. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Wahy project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/cptangry/wahy/blob/master/CODE_OF_CONDUCT.md).
