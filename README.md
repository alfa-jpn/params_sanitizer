# ParamsSanitizer

params_sanitizer sanitize parameter.It is really easy and useful.

## Installation

Add this line to your application's Gemfile:

    gem 'params_sanitizer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install params_sanitizer

## Usage
For example. sanitize params for a search query.
### Define sanitizer.

``` ruby
class SearchParamsSanitizer < ParamsSanitizer::Base
  def self.permit_filter
    [:word, :order]
  end

  exist_value  :word,  ''               # set default value '', when param[:word] does not exist.
  accept_value :order, 1 , ['0','1']    # set default value 1, when param[:order] is not 0 or 1.
end
```

other sanitizer look this.
[ParamsSanitizer::Sanitizers](http://rubydoc.info/github/alfa-jpn/params_sanitizer/ParamsSanitizer/Sanitizers)


and in controller

``` ruby
def search_params
  SearchParamsSanitizer.sanitize(params)  # can get sanitized params.
end
```

result.

``` ruby
{
  word: 'japanese anime',
  unknown_params: 'hogehogehoge',
}

# after sanitize

{
  word: 'japanese anime',
  order: 1
}
```

when params nest.

``` ruby
{
  search: { word: 'japanese anime' }
}
```

``` ruby
def search_params
  SearchParamsSanitizer.sanitize(params, :search)  # can get sanitized params.
end
```

result.

``` ruby
{
  word: 'japanese anime',
  order: 1
}
```

## Sanitizers

- [accept_range](http://rubydoc.info/github/alfa-jpn/params_sanitizer/ParamsSanitizer/Sanitizers/AcceptRange/SanitizerMethods)
- [accept_regex](http://rubydoc.info/github/alfa-jpn/params_sanitizer/ParamsSanitizer/Sanitizers/AcceptRegex/SanitizerMethods)
- [accept_value](http://rubydoc.info/github/alfa-jpn/params_sanitizer/ParamsSanitizer/Sanitizers/AcceptValue/SanitizerMethods)
- [reject_range](http://rubydoc.info/github/alfa-jpn/params_sanitizer/ParamsSanitizer/Sanitizers/RejectRange/SanitizerMethods)
- [reject_regex](http://rubydoc.info/github/alfa-jpn/params_sanitizer/ParamsSanitizer/Sanitizers/RejectRegex/SanitizerMethods)
- [reject_value](http://rubydoc.info/github/alfa-jpn/params_sanitizer/ParamsSanitizer/Sanitizers/RejectValue/SanitizerMethods)
- [exist_value](http://rubydoc.info/github/alfa-jpn/params_sanitizer/ParamsSanitizer/Sanitizers/ExistValue/SanitizerMethods)

## API DOCUMENT

- [ParamsSanitizer](http://rubydoc.info/github/alfa-jpn/params_sanitizer/frames)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
