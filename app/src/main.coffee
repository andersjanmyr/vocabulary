'use strict';

React = require 'react'

app = {}
Page = require './page'
WordForm = require './word-form'
Wordlists = require './wordlists'
Router = require './router'
Service = require './service'

React.initializeTouchEvents(true)

wordFormPage = (list) ->
  Page({ pageClass: 'word-form', content: WordForm({wordlist: list}) })

wordlistsPage = (lists) ->
  Page({ pageClass: 'word-lists', content: Wordlists(wordlists: lists)})

Router.addRoute '/', 'Wordlist', (params) ->
  Service.getWordlists params.filter, (err, lists) ->
    React.render(wordlistsPage(lists), document.body)

Router.addRoute '/wordlists', 'Wordlist', (params) ->
  Service.getWordlists params.filter, (err, lists) ->
    React.render(wordlistsPage(lists), document.body)

Router.addRoute '/wordform/(:id)', 'Wordform', (params) ->
  console.log('params', params)
  if params.id
    Service.getWordlist params.id, (err, list) ->
      console.log('list', err, list)
      React.render(wordFormPage(list), document.body)
  else
    React.render(wordFormPage(), document.body)

Router.addRoute '/wordlists/:id/delete', 'Wordlist delete', (params) ->
  console.log('params', params)
  if params.id
    Service.deleteWordlist params.id, (err, list) ->
      console.log('delete', err, list)
      Router.go('/wordlists')
  else
    React.render(wordFormPage(), document.body)
Router.start()

Router.go('/')


