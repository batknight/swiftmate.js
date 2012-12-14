Swiftmate = window._test.Swiftmate

describe 'Swiftmate', ->

  swiftmate = renderCallback = selectCallback = null

  beforeEach ->
    renderCallback = (term, data, type) -> term
    selectCallback = ->

    setFixtures( sandbox() )
    $('#sandbox').html($('<input type="text" id="search">'))

    swiftmate = new Swiftmate( $('#search'), {
      url:            'http://localhost'
      types:          ['type1', 'type2', 'type3']
      renderCallback: renderCallback
      selectCallback: selectCallback
      minQueryLength: 2
      maxResults: 5
    })

  context 'with a mocked fetchResults method', ->

    beforeEach ->
      swiftmate.fetchResults = ->

    it 'adds a container to the dom with an id of "swiftmate"', ->
      expect( $('#swiftmate') ).toExist()

    describe 'mousing over the input field', ->

      it 'should blur all the suggestions', ->
        expect(-> swiftmate.input.trigger( 'mouseover' ) ).toCall( swiftmate.suggestions, 'blurAll' )

    describe 'pressing a key down in the input field', ->

      keyDown = keyDownEvent = null

      beforeEach ->
        keyDownEvent = $.Event( 'keydown' )
        keyDown = (key) ->
          KEYCODES = {tab: 9, enter: 13, escape: 27, up: 38, down: 40}
          keyDownEvent.keyCode = KEYCODES[key]
          swiftmate.input.trigger( keyDownEvent )

      describe 'escape', ->

        it 'hides the container', ->
          expect( -> keyDown('escape') ).toCall( swiftmate, 'hideContainer' )

      describe 'tab', ->

        tab = -> keyDown('tab')

        it 'selects the currently focused selection', ->
          expect( tab ).toCall( swiftmate.suggestions, 'selectFocused' )

        it 'prevents the default action', ->
          expect( tab ).toCall( keyDownEvent, 'preventDefault' )

      describe 'enter', ->

        enter = -> keyDown('enter')

        it 'selects the currently focused selection', ->
          expect( enter ).toCall( swiftmate.suggestions, 'selectFocused' )

        context 'when no suggestion is focused', ->

          beforeEach ->
            swiftmate.suggestions.allBlured = -> true

          it 'submits the form', ->
            expect( enter ).not.toCall( keyDownEvent, 'preventDefault' )

        context 'when a suggestion is focused', ->

          beforeEach ->
            swiftmate.suggestions.allBlured = -> false

          it 'doesnt submit the form', ->
            expect( enter ).toCall( keyDownEvent, 'preventDefault' )

      describe 'up', ->

        it 'focuses the previous selection', ->
          expect( -> keyDown('up') ).toCall( swiftmate.suggestions, 'focusPrevious' )

      describe 'down', ->

        it 'focuses the next selection', ->
          expect( -> keyDown('down') ).toCall( swiftmate.suggestions, 'focusNext' )

      describe 'any other key', ->

        it 'allows the default action to occur', ->
          expect( -> keyDown('a') ).not.toCall( keyDownEvent, 'preventDefault' )

    describe 'releasing a key in the input field', ->

      keyUp = -> swiftmate.input.trigger( 'keyup' )

      it 'sets the current query value to the value of the input field', ->
        expect( keyUp ).toCallWith( swiftmate.query, 'setValue', [swiftmate.input.val()] )

      context 'when the query has not changed', ->

        beforeEach ->
          swiftmate.query.hasChanged = -> false

        it 'should not fetch new results', ->
          expect( keyUp ).not.toCall( swiftmate, 'fetchResults' )

        it 'should not hide the container', ->
          expect( keyUp ).not.toCall( swiftmate, 'hideContainer' )

      context 'when the query has changed', ->

        beforeEach ->
          swiftmate.query.hasChanged = -> true

        context 'when the query will have results', ->

          beforeEach ->
            swiftmate.query.willHaveResults = -> true

          it 'should blur the suggestions', ->
            expect( keyUp ).toCall( swiftmate.suggestions, 'blurAll' )

          it 'should fetch new results', ->
            expect( keyUp ).toCall( swiftmate, 'fetchResults' )

        context 'when the query will have no results', ->

          beforeEach ->
            swiftmate.query.willHaveResults = -> false

          it 'should hide the container', ->
            expect( keyUp ).toCall( swiftmate, 'hideContainer' )

    context 'showing suggestions', ->

      beforeEach ->
        swiftmate.update( fixtures.responseWithResults.results )

      describe 'clicking outside of the container', ->

        it 'hides the container', ->
          expect( -> $('#sandbox').trigger( 'click.swiftmate') ).toCall( swiftmate, 'hideContainer' )

      describe 'mousing over a suggestion', ->

        it 'should focus that suggestion', ->
          suggestion = swiftmate.suggestions.suggestions[0]
          mouseover = -> suggestion.element().trigger( 'mouseover' )
          expect( mouseover ).toCall( suggestion, 'focus' )

      describe 'clicking a suggestion', ->

        click = suggestion = null

        beforeEach ->
          suggestion = swiftmate.suggestions.suggestions[0]
          click = -> suggestion.element().trigger( 'click' )

        it 'refocuses the input field so it remains active', ->
          click()
          expect( swiftmate.input.is(':focus') ).toBeTruthy()

        it 'selects the clicked suggestion', ->
          expect( click ).toCall( swiftmate.suggestions, 'selectFocused')

    describe '#hideContainer', ->

      it 'blurs all the suggestions', ->
        expect( -> swiftmate.hideContainer() ).toCall( swiftmate.suggestions, 'blurAll' )

      it 'hides the container', ->
        swiftmate.container.show()
        swiftmate.hideContainer()
        expect( swiftmate.container ).toBeHidden()

    describe '#showContainer', ->

      it 'shows the container', ->
        swiftmate.container.hide()
        swiftmate.showContainer()
        expect( swiftmate.container).toBeVisible()

    describe '#update', ->

      context 'with a non-empty result set', ->

        update = -> swiftmate.update( fixtures.responseWithResults.results )

        it 'shows the container', ->
          expect( update ).toCall( swiftmate, 'showContainer' )

        it 'shows the new suggestions', ->
          update()
          expect( swiftmate.container.html() ).toMatch(/2012 Super Bowl/)

      context 'with an empty result set', ->

        update = -> swiftmate.update( fixtures.responseWithNoResults.results )

        it 'hides the container', ->
          expect( update ).toCall( swiftmate, 'hideContainer' )

        it 'marks the current query as empty', ->
          expect( update ).toCall( swiftmate.query, 'markEmpty' )

  # NOTE: Spec-ing jsonp requests is challenging, and these tests are sparse.
  describe '#fetchResults', ->

    beforeEach ->
      swiftmate.query.setValue( 'job' )
      spyOn( $, 'ajax' )
      swiftmate.fetchResults()

    it 'requests the given url as an ajax request', ->
      expect( $.ajax.mostRecentCall.args[0].url ).toEqual( swiftmate.url )

    it 'calls "update" with the responses results on success', ->
      expect( -> $.ajax.mostRecentCall.args[0].success( {results: {}} ) ).toCall( swiftmate, 'update' )

  it "can accept timeout as a parameter", ->
    swiftmate2 = new Swiftmate( $('#search'), {
      url:            'http://localhost'
      types:          ['type1', 'type2', 'type3']
      timeout:        2000
      renderCallback: renderCallback
      selectCallback: selectCallback
      minQueryLength: 2
      maxResults: 5
    })
    expect(swiftmate2.timeout).toNotEqual 500
    expect(swiftmate2.timeout).toEqual 2000
