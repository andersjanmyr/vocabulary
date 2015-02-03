React = require 'react'

Wordlist = require './wordlist'

Dom = React.DOM
module.exports = React.createFactory React.createClass
  render: ->
    Dom.div {id: 'word-list'}, [
      Dom.h1 {}, this.props.wordlist.name
      Dom.div {className: 'languages'}, [
          Dom.div {className: "language #{this.props.wordlist.lang1}"}
          Dom.div {className: "language #{this.props.wordlist.lang2}"}
      ]
      Wordlist({words: this.props.wordlist.words, editable:false}),
      Dom.a({href: '/', className: 'ilink'}, 'Back')
    ]

