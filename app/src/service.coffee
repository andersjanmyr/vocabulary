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

  getWordlists: (filter, callback) ->
    $.ajax({
      type: 'GET'
      contentType: 'application/json'
      dataType: 'json'
      url: "/api/wordlists?filter=#{filter or ''}"
      success: callback.bind(null, null)
    })

  getWordlist: (id, callback) ->
    $.ajax({
      type: 'GET'
      contentType: 'application/json'
      dataType: 'json'
      url: "/api/wordlists/#{id}"
      success: callback.bind(null, null)
    });
}

module.exports = Service
