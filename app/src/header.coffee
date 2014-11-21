React = require 'react'

Dom = React.DOM

LoginPanel = React.createFactory React.createClass

  renderLinks: ->
    if window.user && window.user.email
      Dom.div {id: 'user-panel'}, [
        Dom.span {id: 'user-name'}, "#{user.displayName} (#{user.email}) "
        Dom.a {href: "/logout"}, 'Logout'
      ]
    else
      Dom.a {href: "/auth/google"}, 'Sign In with Google'

  render: ->
    Dom.div {id: 'login-panel'}, [
      this.renderLinks()
    ],

module.exports = React.createFactory React.createClass
  render: ->
    Dom.div {id: 'header'}, [
      Dom.div {id: 'logo'}, [
        Dom.img { id: 'logo-image', src: '/images/victory-128.png'}
              Dom.h1 { id: 'logo-text'}, 'ocabulary'
      ],
      LoginPanel()
    ]

