$ = require('jquery')

Service = {

  saveWordlist: (list, callback) ->
    $.ajax({
      type: if list._id then 'PUT' else 'POST'
      contentType: 'application/json'
      dataType: 'json'
      url: if list._id then "/api/wordlists/#{list._id}" else '/api/wordlists'
      data: JSON.stringify(list)
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
