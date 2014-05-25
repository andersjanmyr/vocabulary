React = require 'react'

WordList = require './word-list'

Dom = React.DOM
module.exports = React.createClass

    getInitialState: ->
        {
            lang1: 'Swedish',
            lang2: 'English',
            words: [
                [ 'Katt', 'Cat'],
                [ 'Hund', 'Dog']
            ]
        }

    languages: [ 'Swedish', 'English', 'Spanish']
    languageOptions: ->
        console.log this.languages
        this.languages.map (lang) ->
            Dom.option {key: lang, value: lang}, lang

    render: ->
        Dom.form {id: 'word-form'}, [
            Dom.div { id: 'languages' }, [
                Dom.select {id: 'lang1 '}, this.languageOptions()
                Dom.select {id: 'lang2 '}, this.languageOptions()
            ]
            WordList({words: this.state.words})
            Dom.div { id: 'inputs' }, [
                Dom.input {id: 'word1 '}
                Dom.input {id: 'word2 '}
            ]
        ]

