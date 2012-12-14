$('#search-input').focus()

render = (data, type) ->
  data.title

$('#search-input').swiftmate {
  engineKey:      '5eMMdfkKCgz5wxyhR9RL' # 'V7U1B7opm5xDnVFnsk5d' is Parse Docs # '5eMMdfkKCgz5wxyhR9RL' is Swiftpye docs
  renderCallback: render
  minQueryLength: 2
  maxResults:     5
}
