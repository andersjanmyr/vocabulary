React = require 'react'
Service = require './service'
Auth = require './auth'

Dom = React.DOM

Wordlists = React.createFactory React.createClass

  renderItem: (item) ->
    Dom.li {key: item._id}, [
      Dom.span {className: 'name'}, item.name
      Dom.span {className: 'amount'}, "(#{item.words.length} words)"
      Dom.div {className: 'owner'}, item.owner
      Dom.a {href: "/wordform/#{item._id}", className: 'ilink'}, 'Edit' if Auth.ownedByCurrentUser(item.owner)
      Dom.a {href: "/wordlists/#{item._id}/delete", className: 'ilink delete'}, 'Delete' if Auth.ownedByCurrentUser(item.owner)
      Dom.a {href: "/quiz/#{item._id}", className: 'ilink'}, 'Quiz'
    ]


  render: ->
    console.log this.props
    self = this
    Dom.div {id: 'wordlists'}, [
      if Auth.currentUser
        Dom.a {href: "/wordform/", className: 'ilink'}, 'New wordlist'
      else
        [Dom.a({href: "/auth/google"}, 'Login')
        ' to create a new wordlist']
      Dom.ul {id: 'wordlists'}, this.props.wordlists.map (item) ->
        console.log(item.name)
        self.renderItem item
    ]

module.exports = Wordlists

