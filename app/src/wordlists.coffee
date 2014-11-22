React = require 'react'
Service = require './service'

Dom = React.DOM

Wordlists = React.createFactory React.createClass

  renderItem: (item) ->
    Dom.li {key: item._id}, [
      Dom.span {className: 'name'}, item.name
      Dom.span {className: 'owner'}, item.owner
      Dom.a {href: "/wordform/#{item._id}"}, 'Edit'
      Dom.a {href: "/quiz/#{item._id}"}, 'Quiz'
    ]


  render: ->
    console.log this.props
    self = this
    Dom.ul {id: 'wordlists'}, this.props.wordlists.map (item) ->
      self.renderItem item

module.exports = Wordlists

