React = require 'react'

Dom = React.DOM
module.exports = React.createClass
    render: ->
        Dom.div {id: 'panel'}, [
            Dom.div { id: 'vocabulary'}, null
            Dom.div { id: 'something'}, null
        ]


