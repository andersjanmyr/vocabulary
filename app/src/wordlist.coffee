React = require 'react'

Dom = React.DOM

EditWordRow = React.createFactory React.createClass
  mixins: [React.addons.LinkedStateMixin]

  stateInput: (name) ->
    Dom.input({
      ref: name,
      type: 'text',
      autocomplete: 'off'
      defaultValue: this.props[name]
    })

  trimSpaces: (word) ->
    word.trim().replace(/\s+/g, ' ')

  save: (e) ->
    e.preventDefault()
    this.props.onSave(
      this.trimSpaces(this.refs.word1.getDOMNode().value),
      this.trimSpaces(this.refs.word2.getDOMNode().value))

  render: ->
    Dom.div {className: 'row'}, [
      this.stateInput('word1'),
      this.stateInput('word2'),
      Dom.button({onClick: this.save}, 'Save')
    ]

  componentDidMount: ->
    word1 = this.refs.word1.getDOMNode()
    word1.focus()
    word1.select()



WordRow = React.createFactory React.createClass
  getInitialState: ->
    {
      editing: false
    }

  edit: (e) ->
    e.preventDefault()
    this.state.editing = true
    this.setState(this.state)

  save: (word1, word2) ->
    console.log('save', word1, word2)
    this.props.pair[0] = word1
    this.props.pair[1] = word2
    this.state.editing = false
    this.setState(this.state)


  render: ->
    if this.state.editing
      EditWordRow({
        word1: this.props.pair[0],
        word2: this.props.pair[1],
        onSave: this.save
      })
    else
      Dom.div {className: 'row', onClick: this.edit}, [
        Dom.div({className: 'word1 '}, this.props.pair[0]),
        Dom.div({className: 'word2 '}, this.props.pair[1])
      ]


module.exports = React.createFactory React.createClass

  renderRows: ->
    this.props.words.map (pair) ->
        WordRow(pair: pair)

  render: ->
    Dom.div {id: 'word-list'}, this.renderRows()

