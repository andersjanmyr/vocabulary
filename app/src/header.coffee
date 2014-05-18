React = require 'react'

Dom = React.DOM
module.exports = React.createClass
    render: ->
        Dom.div {id: 'header'}, [
            Dom.div { id: 'email'}, null
            Dom.div { id: 'login'}, null
        ]



