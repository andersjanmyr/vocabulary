React = require 'react'

WordList = require './word-list'

Dom = React.DOM
module.exports = React.createFactory React.createClass
  mixins: [React.addons.LinkedStateMixin]
  getInitialState: ->
    {
      inputWord1: null,
      inputWord2: null,
      message: null,
      wordList: $.extend(true, {}, this.props.wordList)
    }

  languages: [ 'Swedish', 'English', 'Spanish']
  languageOptions: (selectedLang) ->
    this.languages.map (lang) ->
      Dom.option {key: lang, value: lang}, lang

  onClick: (e) ->
    console.log this.state.wordList
    e.preventDefault()
    state = this.state
    words = this.state.wordList.words
    exists1 = words.some (pair) ->
      return true if pair[0] is state.inputWord1
    exists2 = words.some (pair) ->
      return true if pair[1] is state.inputWord2

    if exists1 or !state.inputWord1
      this.state.message = 'Word already exists, not added!'
      elWord1 = this.refs.inputWord1.getDOMNode()
      elWord1.focus()
      elWord1.select()
    else if exists2 or !state.inputWord2
      this.state.message = 'Word already exists, not added!'
      elWord2 = this.refs.inputWord2.getDOMNode()
      elWord2.focus()
      elWord2.select()
    else
      this.state.message = null
      elWord1 = this.refs.inputWord1.getDOMNode().focus()
      words.push [this.state.inputWord1, this.state.inputWord2]
      this.state.inputWord1 = ''
      this.state.inputWord2 = ''
    this.setState(this.state)

  componentDidMount: ->
    this.refs.inputWord1.getDOMNode().focus()


  message: ->
    if this.state.message
      Dom.div {id: 'message'}, this.state.message

  stateInput: (name) ->
    Dom.input({
      ref: name,
      type: 'text',
      valueLink: this.linkState(name)
    })


  render: ->
    Dom.form {id: 'word-form'}, [
      this.message(),
      Dom.input({
        id: 'form-name',
        ref: 'name',
        placeholder: 'Book, chapter, ...'
        value: this.state.wordList.name,
        onChange: =>
          this.state.wordList.name = this.refs.name.getDOMNode().value
          this.setState(this.state)
      }),
      Dom.div({ id: 'languages' }, [
        Dom.select({ id: 'lang1', valueLink: this.linkState('lang1')},
          this.languageOptions())
        Dom.select({ id: 'lang2', valueLink: this.linkState('lang2')},
          this.languageOptions())
      ]),
      WordList({words: this.state.wordList.words}),
      Dom.div({ id: 'inputs' }, [
        this.stateInput('inputWord1'),
        this.stateInput('inputWord2'),
        Dom.button({ref: 'addButton', onClick: this.onClick}, 'Add words')
      ])
    ]

