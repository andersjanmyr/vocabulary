React = require 'react'

Dom = React.DOM
module.exports = React.createClass

    renderRow: (pair) ->
        Dom.div {className: 'row '}, [
            Dom.div({className: 'word1 '}, pair[0]),
            Dom.div({className: 'word2 '}, pair[1])
        ]

    renderRows: ->
        this.props.words.map(this.renderRow)

    render: ->
        Dom.div {id: 'word-list'}, this.renderRows()

