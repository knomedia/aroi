# aroi

[![Build Status](https://travis-ci.org/knomedia/aroi.svg)](https://travis-ci.org/knomedia/aroi)

(A)ctive (R)ecord (O)bject (I)nstrumenter

Adds ActiveSupport::Notifications instrument calls to the creation of any
ActiveRecord object.

## Usage

Include the gem

```` ruby
gem 'aroi'
```

Bundle your app and add a rails initializer

```` ruby
# config/initializers/aroi.rb

Aroi::Instrumentation.instrument_creation!

ActiveSupport::Notifications.subscribe(/instance.active_record/) do |name, start, finish, id, payload|
  # name, start, finish, id are all the same as usual for notifications
  puts "Created a #{payload[:name]} object"
end
````

`aroi` will dispatch `'instance.active_record'` any time an ActiveRecord object is instantiated.

See the [ActiveSupport::Notifications
docs](http://api.rubyonrails.org/classes/ActiveSupport/Notifications.html) for
more information on how to subscribe to instrumented notifications.


## Why

Rails 3 brought about ActiveSupport::Notifications as a way to subscribe to
different actions that happen within your rails application. You can use it to
instrument how long a controller action takes, how much of that time was spent
creating views verses querying the DB. At times it may be worth instrumenting
the number of ActiveRecord objects that have been created per controller
action. This gem provides the foundation to doing so.


## Credit

Heavily inspired by [Oink](https://github.com/noahd1/oink). `oink` does some
great things with logging. We borrow some of those ideas but fire off
ActiveSupport::Notifications instead of logging.


## Contributing

1. Fork it ( https://github.com/knomedia/aroi/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
