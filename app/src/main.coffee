'use strict';

React = require 'react'

app = {}
Header = require './header'
Panel = require './panel'

React.initializeTouchEvents(true);

Dom = React.DOM
Main = React.createClass
  render: ->
    Dom.div {id: 'main'}, [
      Header()
          Panel()
    ]

console.log document.body

React.renderComponent(Main(), document.body);


