$ = require('jquery')

MessagePanel = require './message-panel'
$(document).ajaxError (event, jqxhr, settings, thrownError) ->
  console.log(event, jqxhr, settings, thrownError)
  MessagePanel.showError("#{event} - #{thrownError}")

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
    })

  deleteWordlist: (id, callback) ->
    $.ajax({
      type: 'DELETE'
      contentType: 'application/json'
      dataType: 'json'
      url: "/api/wordlists/#{id}"
      success: callback.bind(null, null)
    })

  saveStats: (stats, callback) ->
    $.ajax({
      type: 'POST'
      contentType: 'application/json'
      dataType: 'json'
      url: '/api/stats'
      data: JSON.stringify(stats)
      success: callback.bind(null, null)
    })

  getStatsByUser: (email, callback) ->
    $.ajax({
      type: 'GET'
      contentType: 'application/json'
      dataType: 'json'
      url: "/api/stats/#{email}"
      success: callback.bind(null, null)
    })


}

module.exports = Service
