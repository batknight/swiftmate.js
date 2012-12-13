$('#search-input').focus()

render = (data, type) ->
  # inspect the data object
  console.log([data, type])
  # what should be displayed?
  data.full_name
  # switch type

select = (data, type) ->
  console.log("Selected #{data.title}; Url: #{data.url}")
  # Point browser to new page
  # window.location = data.url

$('#search-input').soulmate {
  engineKey:      'o7YDspiPRqV7szcQRQpo' # 'V7U1B7opm5xDnVFnsk5d' is Parse Docs
  renderCallback: render
  minQueryLength: 2
  maxResults:     5
}

$('#search-input-2').soulmate {
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

  renderCallback: render
  selectCallback: select
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
