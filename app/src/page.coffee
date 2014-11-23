React = require 'react'
Header = require './header'

Dom = React.DOM
module.exports = React.createFactory React.createClass
  render: ->
    Dom.div {id: 'page', class: this.props.pageClass}, [
      Dom.div {id: 'message'}
      new Header(),
      Dom.div {id: 'content'}, this.props.content
      Dom.div {id: 'footer'}, [
        Dom.div({id: 'issues'}, [
          'Report bugs and request new features at ',
          Dom.a({href: 'https://github.com/andersjanmyr/vocabulary/issues', target:'_blank'}, 'Gihub Issues')
        ]),
        Dom.div({id: 'contact'}, [
          'Version 0.9, by Anders Janmyr ',
          Dom.a({href: 'http://anders.janmyr.com/', target:'_blank'}, 'anders.janmyr.com')
        ])
      ]
    ]


