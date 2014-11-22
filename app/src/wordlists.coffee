React = require 'react'
Service = require './service'

Dom = React.DOM

Wordlists = React.createFactory React.createClass

  renderItem: (item) ->
    Dom.li {key: item._id}, [
      Dom.span {className: 'name'}, item.name
      Dom.span {className: 'owner'}, item.owner
      Dom.span {className: 'amount'}, "(#{item.words.length} words)"
      Dom.a {href: "/wordform/#{item._id}"}, 'Edit'
      Dom.a {href: "/quiz/#{item._id}"}, 'Quiz'
    ]


  render: ->
    console.log this.props
    self = this
    Dom.div {id: 'wordlists'}, [
      Dom.a {href: "/wordform/"}, 'New'
      Dom.ul {id: 'wordlists'}, this.props.wordlists.map (item) ->
        console.log(item.name)
        self.renderItem item
    ]

module.exports = Wordlists

