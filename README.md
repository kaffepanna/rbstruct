# Rbstruct
[![Build Status](https://travis-ci.org/kaffepanna/rbstruct.svg?branch=master)](https://travis-ci.org/kaffepanna/rbtelldus)

## What is RbStruct

RbStruct is a ruby library providing a way of describing structured binary data much like structs in C are declared. RbStruct uses ruby arrays to hold data in memory and should be fairly fast.

## History

The first iteration of this library was created in late 2008 and put up on google code and forgotton. Initialy it was used for reading quake3
level and player model datafiles to be used in a game engine. The code was forgotten for about 6 years until I needed a way of modifing partitions and
I decided to make a gem out of it and put it on github.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rbstruct'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rbstruct

## Usage

RbStruct defines a kind of dsl to resembel how structs are declared in C.

Example of GPT partition header:
```ruby
GptHeader = RbStruct do
  unsigned_char :signature, 8
  unsigned_int  :revision
  unsigned_int  :header_size
  unsigned_int  :crc32
  unsigned_int  :revserved
  unsigned_long :current_lba
  unsigned_long :backup_lba
  unsigned_long :first_lba
  unsigned_long :last_lba
  unsigned_char :guid, 16
  unsigned_long :partition_array_lba
  unsigned_int  :n_partition_array
  unsigned_int  :partition_entry_size
  unsigned_int  :partition_array_crc32
end
```

Fields are described by `<type> <symbol>, <number of elements>`. Nested structs are also supported

Ex:
```ruby
Bsp46DirEntry = RbStruct do
  int :offset
  int :n
end

Bsp46Header = RbStruct do
  unsigned_char :magic, 4
  int           :version
  struct        Bsp46DirEntry, :direntries, 17
end
```

Reading and writing:
```ruby
f = File.open('map.bsp', 'r')
header = Bsp46Header.read(f)

header.write(f)
```

You can also choose to read multiple structs from the file in one go
```ruby
# this wouldt make sense but sure
headers = Bsp46Header.read(f, 10)
```

Getting and setting values:
```ruby
# Get value
header.version

# Set value
header.version = 10
```

RbStructs are also flexible letting you define your own methods on the structs
```ruby
Example = RbStruct do
  int :version
  def bump_version
    version = version+1
  end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kaffepanna/rbstruct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

