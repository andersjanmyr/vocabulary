$ = require('jquery')

Service = {
  saveWordlist: (wordlist, callback) ->
    $.ajax({
      type: 'POST'
      contentType: 'application/json'
      dataType: 'json'
      url: '/api/wordlists'
      data: JSON.stringify(wordlist)
      success: callback.bind(null, null)
    })

  getWordlists: (callback) ->
    $.ajax({
      type: 'GET'
      contentType: 'application/json'
      dataType: 'json'
      url: '/api/wordlists'
      success: callback.bind(null, null)
    });

}

module.exports = Service
