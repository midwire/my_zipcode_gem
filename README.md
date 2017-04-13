# My Zipcode Gem

[![MIT-LICENSE](https://img.shields.io/github/license/midwire/my_zipcode_gem.svg)](https://github.com/midwire/my_zipcode_gem/blob/master/MIT-LICENSE)

Simple gem to handle zipcode lookups and related functionality.  `rake zipcodes:update` will automatically download and update your local zipcode database.  Generates three models for extended zipcode functionality.

## Versions

* 0.1.x is for Rails versions less than 4.x
* 0.2.x is for Rails 4 and above

## Installation

Add the following line to your Gemfile:

```ruby
gem 'my_zipcode_gem'
```

Run:

```bash
rake bundle install
```

Generate the models and populate the data:

```bash
rails g my_zipcode_gem:models
# here you may need to run "bundle install" again for dependencies
rake db:migrate
rake zipcodes:update # this will take some time, be patient
```

You should now have three new tables and three new models, Zipcode, State, County.

## Usage

```ruby
zipcode = Zipcode.find_by_code '66206'
zipcode.state.abbr    # => 'KS'
zipcode.city          # => 'Shawnee Mission'
zipcode.county.name   # => 'Johnson'
zipcode.lat.to_s      # => '38.959356', it is actually a BigDecimal object converted to_s for documentation.
zipcode.lon.to_s      # => '-94.716155', ditto
zipcode.geocoded?  # => true, most if not all should be pre-geocoded.
```

You can also look for a zipcode from a city and state:

```ruby
Zipcode.find_by_city_state "Shawnee Mission", "KS"
```

You can use State and County objects as follows:

```ruby
state = State.find_by_abbr "MO"
state.cities.count    # => 963
state.cities          # gives you a sorted array of all cities for the state
state.zipcodes.count  # => 1195
...
county = state.counties.first
county.cities.count   # => 5
county.cities         # gives you a sorted array of all cities for the county
county.zipcodes.count # => 5
```

### Automatic JQuery/AJAX lookup

You can have a user enter a zipcode and automatically lookup their city, state and county.

Put something like this in your view:

```ruby
f.text_field :zip, size: 5, maxlength: 5, class: 'zipcode_interactive'
f.text_field :city, size: 20, maxlength: 60, readonly: true
f.text_field(:state, size: 2, maxlength: 2, readonly: true)
f.text_field(:county, size: 20, maxlength: 60, readonly: true)
```

Then add this to your application.js, but remember to replace `mycontrollername` with your own controller.

```javascript
$(document).ready(function() {
  // Interactive Zipcodes
  $('input.zipcode_interactive').blur(function(data) {
    var elem_id = $(this).attr("id");
    var base_id = elem_id.substring(0, elem_id.lastIndexOf("_"));
    $.get("/mycontrollername/get_zip_data/" + this.value, {},
    function(data) {
      var zipcode = $.parseJSON(data);
      var city = $('#' + base_id + '_city');
      var state = $('#' + base_id + '_state');
      var county = $('#' + base_id + '_county');
      if (zipcode.err) {
        alert(zipcode.err);
      } else {
        city.val(zipcode.city);
        state.val(zipcode.state)
        county.val(zipcode.county)
      }
    })
  });
});
```

You will also need a controller method similar to this, which will return the data to your form:

```ruby
def get_zip_data
  @zipcode = Zipcode.find_by_code(params[:code], include: [:county, :state])
  if @zipcode
    @counties = County.find(:all, conditions: [ "state_id = ?", @zipcode.county.state_id ])
    data = {
      'state' => @zipcode.state.abbr,
      'county' => @zipcode.county.name,
      'city' => @zipcode.city.titleize
    }
    render text: data.to_json
  else
    if params[:code].blank?
      return true
    else
      if params[:code].is_zipcode?
        data = {
          'err' => "Could not find Zipcode [#{params[:code]}].  If this is a valid zipcode please notify support <support@mydomain.com>, so we can update our database."
        }
      else
        data = {
          'err' => "[#{params[:code]}] is not a valid Zipcode."
        }
      end
      render text: data.to_json
    end
  end
end
```

And define a route for the AJAX function in routes.rb:

```ruby
get 'mycontrollername/get_zip_data/:code', controller: 'mycontrollername', action: 'get_zip_data'
```

That's about it.

Please report any errors or [issues](https://github.com/midwire/my_zipcode_gem/issues).

## LOG

### 05/03/2011:

Initial Release
