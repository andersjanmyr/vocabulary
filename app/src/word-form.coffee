React = require 'react'

Wordlist = require './wordlist'
MessagePanel = require './message-panel'
Auth = require './auth'
Router = require './router'
Service = require './service'

emptyList = {
  name: "New list"
  owner: Auth.owner
  lang1: "Swedish"
  lang2: "English"
  words: []
}

Dom = React.DOM
module.exports = React.createFactory React.createClass
  mixins: [React.addons.LinkedStateMixin]
  getInitialState: ->
    {
      inputWord1: null,
      inputWord2: null,
      wordlist: $.extend(true, {}, this.props.wordlist or emptyList)
    }

  languages: [ 'Swedish', 'English', 'Spanish']
  languageOptions: (selectedLang) ->
    this.languages.map (lang) ->
      Dom.option {key: lang, value: lang}, lang

  addClicked: (e) ->
    e.preventDefault()
    state = this.state
    words = this.state.wordlist.words
    exists1 = words.some (pair) ->
      return true if pair[0] is state.inputWord1
    exists2 = words.some (pair) ->
      return true if pair[1] is state.inputWord2

    if exists1 or !state.inputWord1
      MessagePanel.showError("Word already exists, #{state.inputWord1}, not added!")
      elWord1 = this.refs.inputWord1.getDOMNode()
      elWord1.focus()
      elWord1.select()
    else if exists2 or !state.inputWord2
      MessagePanel.showError("Word already exists, #{state.inputWord2}, not added!")
      elWord2 = this.refs.inputWord2.getDOMNode()
      elWord2.focus()
      elWord2.select()
    else
      elWord1 = this.refs.inputWord1.getDOMNode().focus()
      words.push [this.state.inputWord1, this.state.inputWord2]
      this.state.inputWord1 = ''
      this.state.inputWord2 = ''
    this.setState(this.state)

  saveClicked: (e) ->
    console.log this.state.wordlist
    e.preventDefault()
    if Auth.ownedByCurrentUser(this.state.wordlist.owner)
      Service.saveWordlist this.state.wordlist, (err, wordlist) ->
        console.log(err, wordlist)
        return MessagePanel.showError("Cannot save wordlist, #{err}") if err
        Router.go('/wordlists')
    else
      MessagePanel.showError("You can't save someone else's wordlist, owned by:
        #{this.state.wordlist.owner}")

  cancelClicked: (e) ->
    e.preventDefault()
    Router.go('/wordlists')

  componentDidMount: ->
    this.refs.inputWord1.getDOMNode().focus()


  stateInput: (name) ->
    Dom.input({
      ref: name,
      type: 'text',
      valueLink: this.linkState(name)
    })

  langSelect: (name) ->
    Dom.select({
      ref: name
      value: this.state.wordlist[name]
      onChange: =>
        this.state.wordlist[name] = this.refs[name].getDOMNode().value
        this.setState(this.state)
      },
      this.languageOptions()
    )


  render: ->
    Dom.form {id: 'word-form'}, [
      Dom.input({
        id: 'form-name',
        ref: 'name',
        placeholder: 'Book, chapter, ...'
        value: this.state.wordlist.name,
        onChange: =>
          this.state.wordlist.name = this.refs.name.getDOMNode().value
          this.setState(this.state)
      }),
      Dom.div({ id: 'languages' }, [
        this.langSelect('lang1')
        this.langSelect('lang2')
      ]),
      Wordlist({words: this.state.wordlist.words}),
      Dom.div({ id: 'inputs' }, [
        this.stateInput('inputWord1'),
        this.stateInput('inputWord2'),
        Dom.button({ref: 'addButton', onClick: this.addClicked}, 'Add words')
      ])
      Dom.div { id: 'save-panel' }, [
        Dom.button({ref: 'saveButton', onClick: this.saveClicked}, 'Save wordlist')
        Dom.button({ref: 'cancelButton', onClick: this.cancelClicked}, 'Cancel')
      ]
    ]

