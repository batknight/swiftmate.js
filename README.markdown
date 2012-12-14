# swiftmate.js

Swiftmate.js is a jQuery plugin for retrieving autocompletion suggestions from a hosted [Swiftype](http://swiftype.com) search engine. Swiftmate provides well structured markup you can freely style to fit your website's design.

Swiftmate.js based on [soulmate.js](https://github.com/mcrowe/soulmate.js), a jQuery front-end interface for the
[soulmate](https://github.com/seatgeek/soulmate) autocompletion backend by seetgeak.

## Demo

Get wowed by this demo of [**swiftmate.js in action**](http://thomasklemm.github.com/swiftmate.js).

![Swiftmate](https://f.cloud.github.com/assets/1100176/13183/560ee146-45ea-11e2-9f3a-0075d0065875.png)

## Features

* **Clean markup:** Renders a clean and semantic markup structure that is easy to style.
* **Customizable behaviour:** Customized rendering of suggestions through a callback that provides all stored data for that suggestion. Customized suggestion selection behaviour through a callback.
* **Adaptable:** A modular, object-oriented design, that is meant to be very easy to adapt and modify.

## Basic usage

```coffee
# Callback rendering each item of each documentType
render = (data, type) ->
  book = data
  "#{ book.title } by #{ book.author }"

$('#search-input').swiftmate {
  engineKey:       '5eMMdfkKCgz5wxyhR9RL' # Swiftype Docs Crawler Engine
  renderCallback:  render
  maxResults:      5
}
```

## Advanced usage

Swiftmate supports all search options outlined to be supported by the autocompletion API in the Swiftype [autocompletion](http://swiftype.com/documentation/autocomplete) and [search](http://swiftype.com/documentation/searching) docs.

```coffee
# Render Callback
render = (data, type) ->
  # inspect the input
  console.log([data, type])
  # build output text or html string
  # e.g. "<b>Harry Potter and the Philospher's Stone</b> by J.K. Rowling"
  "<b>#{ data.title }</b> by #{ data.author }"

# Select Callback
select = (data, type) ->
  console.log("Selected #{data.title}; Url: #{data.url}")
  # Point browser to new page
  window.location = data.url

$('#search-input').swiftmate {
  ##
  # BASIC OPTIONS

  # engineKey
  #  => identifies your Swiftype engine
  #     not equivalent to your API key, keep the API key secret!
  engineKey:      '123abc123abc123abc'

  # documentTypes
  #  => an array of DocumentTypes to retrieve
  #     default: null => retrieves all DocumentTypes
  documentTypes:  ['books', 'magazines']

  # searchFields
  #  => a hash containing arrays of the fields you want to match your query against for each object of each DocumentType
  #     default: null => will autocomplete against all string fields (check!)
  #       You can add a field weight using 'title^3' notation
  searchFields: {
    'books': ['title^3', 'author']
  }

  # sortField and sortDirection
  #  => default: null => sort by matching score
  sortField: {'books': 'price'}
  sortDirection: {'books': 'asc'}

  # fetchFields
  #  => a hash containing arrays of the fields you want to have returned for each object of each DocumentType
  #     default: null => fetches all fields
  fetchFields: {
    'books': ['author','title','price']
  }

  # maxResults
  #  => number of results per DocumentType (check!); corresponds with Swiftype's 'per_page' option
  #     default: 5
  maxResults: 10

  # renderCallback
  #   function with arguments (data, type)
  #   that return the text or html of the rendered suggestion
  # Examples:
  #   render = (data, type) ->
  #     data.title
  #
  #   render = (data, type) ->
  #     "<b>#{ data.title }</b>"
  #
  #   render = (data, type) ->
  #     console.log(data)
  #     "<b>" + data.title + "</b>"
  #
  #   # You can render different types differently
  #   render = (data, type) ->
  #     switch type
  #       when 'magazine' then
  #         magazine = data
  #         magazine.title
  #       when 'book' then
  #         book = data
  #         "#{ data.title } <em>by #{ data.author }</em>"
  #       else
  #         console.log(data)
  #         data.title
  #
  renderCallback: render

  # selectCallback
  #   function with arguments (data, type)
  #   defaults to following the data.url link if present
  # Examples:
  #   select = (data, type) ->
  #     console.log("Selected #{ data.title }")
  #     alert("Selected #{ data.title }")
  #
  #   # This is the default selectCallback
  #   select = (data, type) ->
  #     window.location = data.url
  #
  selectCallback: select

  # minQueryLength
  #   minimal length of the query to trigger an ajax request
  minQueryLength: 2

  ##
  # ADVANCED OPTIONS

  # filters
  # Filters allow you to restrict the result set of a query by applying conditions to fields on the matching
  #  => a hash specifying additional conditions that should be applied to your query for each DocumentType
  #     default: null => no filters applied
  filters: {
    'books': {'in_stock': true, 'genre': 'fiction' }
  }

  # functionalBoosts
  #  => Functional boosts allow you to boost result scores based on some numerically valued field.
  #     Functional boosts may be applied to integer and float fields. See the Swiftype Docs for more info.
  #     default: null
  functionalBoosts: {
    'books': {'total_purchases': 'logarithmic'}
  }

  # facets
  #  => You can use faceting to give you a count of results for each value of a particular field.
  #     default: null => no facets, no counts
  facets: {
    'books': ['genre']
  }

  # timeout
  #  => timeout for the ajax request to the Swiftype API in milliseconds
  #     default: 1000 => default is 1000 milliseconds == one second
  timeout: 1500
}

```

## Styling

The generated semantic structure will look like this. See the `demo/demo.scss` for an example.

```scss
#swiftmate {
  .swiftmate-type-container {
    &:first-child {}
  }

  .swiftmate-type-suggestions {
  }

  .swiftmate-suggestion {
    &.focus{}
  }

  .swiftmate-type {
  }
}
```
## Credits

Many thanks to [**Mitch Crowe**](http://mitchcrowe.com/) for creating and open-sourcing [soulmate.js](https://github.com/mcrowe/soulmate.js), on which Swiftype.js is based. Mitch also created the demo page and it's styles, being in turn inspired by [seatgeek](http://seatgeek.com/) and [premiumpixels](http://www.premiumpixels.com/).

## Contributing

Feel free to fork this repo and edit the source files. You can have the source and demo files automatically be recompiled on file changes in development by running `thor swiftmate:watch`. For more tasks run `thor list`.

Open an issue for any questions of contact me at github@tklemm.eu or [@thomasjklemm](https://twitter.com/thomasjklemm) on Twitter.

Best,
Thomas
