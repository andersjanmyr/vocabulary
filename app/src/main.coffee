'use strict';

React = require 'react'

app = {}
Page = require './page'
WordForm = require './word-form'
Wordlists = require './wordlists'
Router = require './router'
Service = require './service'

React.initializeTouchEvents(true)

wordlist = {
  name: 'A new demo list'
  owner: 'anders@janmyr.com'
  lang1: 'Swedish'
  lang2: 'English'
  words: [
    [ 'Fisk', 'Fisk']
    [ 'Katt', 'Cat']
    [ 'Hund', 'Dog']
  ]
}

wordFormPage = (list) ->
  Page({ pageClass: 'word-form', content: WordForm({wordlist: list}) })

wordlistsPage = (lists) ->
  Page({ pageClass: 'word-lists', content: Wordlists(wordlists: lists)})

Router.addRoute '/wordform/:id', 'Wordform', (params) ->
  console.log('params', params)
  Service.getWordlist params.id, (err, list) ->
    console.log('list', err, list)
    React.render(wordFormPage(list), document.body)

Router.addRoute '/', 'Wordlist', (filter) ->
  Service.getWordlists filter, (err, lists) ->
    React.render(wordlistsPage(lists), document.body)

Router.start()

Router.go('/')


