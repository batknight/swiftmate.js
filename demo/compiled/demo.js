(function() {
  var render, select;
  $('#search-input').focus();
  render = function(data, type) {
    return data.owner + "/<b>" + data.name + "</b> (" + data.stars + " stars)";
  };
  select = function(data, type) {
    return console.log("Selected " + data.full_name);
  };
  $('#search-input').soulmate({
    renderCallback: render,
    selectCallback: select,
    minQueryLength: 2,
    maxResults: 5,
    engineKey: 'o7YDspiPRqV7szcQRQpo'
  });
}).call(this);
