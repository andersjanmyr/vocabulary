React = require 'react'

Dom = React.DOM

WordRow = React.createFactory React.createClass
  mixins: [React.addons.LinkedStateMixin]
  getInitialState: ->
    {
      editing: false
      first: true
      word1: this.props.pair[0]
      word2: this.props.pair[1]
    }

  edit: (e) ->
    e.preventDefault()
    this.state.editing = true
    this.setState(this.state)

  save: (e) ->
    e.preventDefault()
    this.state.editing = false
    this.state.first = true
    this.props.pair[0] = this.state.word1
    this.props.pair[1] = this.state.word2
    this.setState(this.state)

  componentDidUpdate: ->
    if this.state.editing and this.state.first
      this.state.first = false
      word1 = this.refs.word1.getDOMNode()
      word1.focus()
      word1.select()

  stateInput: (name) ->
    Dom.input({
      ref: name,
      type: 'text',
      valueLink: this.linkState(name)
    })

  render: ->
    if this.state.editing
      Dom.div {className: 'row'}, [
        this.stateInput('word1'),
        this.stateInput('word2'),
        Dom.button({onClick: this.save}, 'Save')
      ]
    else
      Dom.div {className: 'row', onClick: this.edit}, [
        Dom.div({className: 'word1 '}, this.state.word1),
        Dom.div({className: 'word2 '}, this.state.word2)
      ]


module.exports = React.createFactory React.createClass

  renderRows: ->
    this.props.words.map (pair) ->
        WordRow(pair: pair)

  render: ->
    Dom.div {id: 'word-list'}, this.renderRows()

