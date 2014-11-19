'use strict';

React = require 'react'

app = {}
Page = require './page'
WordForm = require './word-form'

React.initializeTouchEvents(true)

wordList = {
  name: 'A new demo list',
  lang1: 'Swedish',
  lang2: 'English',
  words: [
    [ 'Fisk', 'Fisk'],
    [ 'Katt', 'Cat'],
    [ 'Hund', 'Dog']
  ]
}

wordListPage = Page({
  pageClass: 'word-form',
  content: WordForm({wordList: wordList})})

React.render(wordListPage, document.body);


