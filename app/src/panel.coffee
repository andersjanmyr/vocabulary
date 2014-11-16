React = require 'react'
WordForm = require './word-form'

Dom = React.DOM
module.exports = React.createClass
  render: ->
    Dom.div {id: 'panel'}, [
      new WordForm(),
          Dom.div { id: 'something'}, null
    ]


