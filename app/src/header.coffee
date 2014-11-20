React = require 'react'

Dom = React.DOM
module.exports = React.createFactory React.createClass
  render: ->
    Dom.div {id: 'header'}, [
      Dom.div {id: 'logo'}, [
        Dom.img { id: 'logo-image', src: '/images/victory-128.png'}
              Dom.h1 { id: 'logo-text'}, 'ocabulary'
      ],
      Dom.div {id: 'login'}, [
        Dom.a {href: "/auth/google"}, 'Sign In with Google'
      ],

    ]

