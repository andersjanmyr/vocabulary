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
            ],
            message: null
        }

    languages: [ 'Swedish', 'English', 'Spanish']
    languageOptions: (selectedLang) ->
        this.languages.map (lang) ->
            Dom.option {key: lang, value: lang }, lang

    onClick: (e) ->
        newPair = [
            this.refs.word1.getDOMNode().value,
            this.refs.word2.getDOMNode().value
        ]
        duplicates = this.state.words.filter (pair) ->
            return pair if pair[0] is newPair[0] or pair[1] is newPair[1]

        if duplicates.length > 0
            this.state.message = 'Words already exists, not added!'
        else
            this.state.words.push newPair
        this.setState(this.state)

    message: ->
        if this.state.message
            Dom.div {id: 'message'}, this.state.message

    render: ->
        Dom.form {id: 'word-form'}, [
            this.message(),
            Dom.div { id: 'languages' }, [
                Dom.select {id: 'lang1 ', defaultValue: this.state.lang1}, this.languageOptions()
                Dom.select {id: 'lang2 ', defaultValue: this.state.lang2}, this.languageOptions()
            ],
            WordList({words: this.state.words}),
            Dom.div { id: 'inputs' }, [
                Dom.input {ref: 'word1', type: 'text'}
                Dom.input {ref: 'word2', type: 'text'}
                Dom.input {type: 'button', value: 'Add',  onClick: this.onClick}
            ]
        ]

