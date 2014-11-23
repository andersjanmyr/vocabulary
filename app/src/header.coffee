React = require 'react'

Dom = React.DOM

LoginPanel = React.createFactory React.createClass

  renderLinks: ->
    if window.user && window.user.email
      Dom.div {id: 'user-panel'}, [
        Dom.img {id: 'user-picture', src: user.picture, width: '48', height: '48'}
        Dom.div {}, [
          Dom.div {id: 'user-name'}, "#{user.displayName} (#{user.email})"
          Dom.div {}, Dom.a {href: "/logout"}, 'Logout'
        ]
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
      Dom.a {href: "/", className: 'ilink'},
        Dom.div {id: 'logo'}, [
          Dom.img { id: 'logo-image', src: '/images/victory-128.png'}
                Dom.h1 { id: 'logo-text'}, 'ocabulary'
        ],
      LoginPanel()
    ]

