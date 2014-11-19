React = require 'react'
Header = require './header'

Dom = React.DOM
module.exports = React.createFactory React.createClass
  render: ->
    Dom.div {id: 'page', class: this.props.pageClass}, [
      Dom.div {id: 'message'}
      new Header(),
      Dom.div {id: 'content'}, this.props.content
    ]


