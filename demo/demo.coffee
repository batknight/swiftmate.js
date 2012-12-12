$('#search-input').focus()

render = (term, data, type) -> term
select = (term, data, type) -> console.log("Selected #{term}")

$('#search-input').soulmate {
  types:          ['teamband', 'event', 'venue', 'tournament']
  renderCallback: render
  selectCallback: select
  minQueryLength: 2
  maxResults:     8
}
