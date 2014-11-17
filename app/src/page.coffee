React = require 'react'
Header = require './header'

Dom = React.DOM
module.exports = React.createFactory React.createClass
  render: ->
    Dom.div {id: 'page', class: this.props.pageClass}, [
      new Header(),
      Dom.div {id: 'content'}, this.props.content
    ]


