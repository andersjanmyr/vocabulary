'use strict';

React = require 'react'

app = {}
Page = require './page'
WordForm = require './word-form'
Wordlists = require './wordlists'
Router = require './router'

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

wordFormPage = Page({
  pageClass: 'word-form',
  content: WordForm({wordlist: wordlist})
})

wordlistsPage = Page({
  pageClass: 'word-lists',
  content: Wordlists()
})

Router.addRoute '/', ->
  React.render(wordFormPage, document.body)

Router.addRoute '/wordlists', ->
  React.render(wordlistsPage, document.body)

Router.start()

Router.go('/', 'Vocabulary')


