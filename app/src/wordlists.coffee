React = require 'react'
Service = require './service'

Dom = React.DOM

Wordlists = React.createFactory React.createClass

  getInitialState: ->
    {
      lists: []
    }

  componentDidMount: ->
    self = this
    Service.getWordlists (err, lists) ->
      console.log(self.state, lists)
      self.state.lists = lists
      self.setState(self.state)

  renderItem: (item) ->
    Dom.li {key: item._id}, [
      Dom.span {className: 'name'}, item.name
      Dom.span {className: 'owner'}, item.owner
      Dom.a {href: "/wordlists/#{item._id}"}, 'Edit'
      Dom.a {href: "/quiz/#{item._id}"}, 'Quiz'
    ]


  render: ->
    self = this
    Dom.ul {id: 'wordlists'}, this.state.lists.map (item) ->
      self.renderItem item

module.exports = Wordlists

