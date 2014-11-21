'use strict';

React = require 'react'

app = {}
Page = require './page'
WordForm = require './word-form'

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

wordlistPage = Page({
  pageClass: 'word-form',
  content: WordForm({wordlist: wordlist})})

React.render(wordlistPage, document.body);


