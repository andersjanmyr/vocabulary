React = require 'react'

_ = require('lodash')
MessagePanel = require './message-panel'
Auth = require './auth'
Router = require './router'
Service = require './service'

Dom = React.DOM

UserPanel = React.createFactory React.createClass
  render: ->
    stats = this.props.stats
    user = window.user
    console.log(stats)
    Dom.div {id: 'user-page'}, [
      Dom.img {className: 'user-large-picture', src: user.picture}
      Dom.h2 {className: 'username'}, user.displayName
      Dom.h3 {id: 'email'}, user.email
      Dom.div {id: 'stats-panel'}, [
        Dom.h2({}, 'Stats')
        Dom.div({className: 'count'}, stats.count, ' quizzes taken')
        Dom.div({className: 'perfect'},
          "#{stats.perfect} perfect (#{stats.perfectPerc}%)")
        Dom.div({className: 'ok'},
          "#{stats.ok} OK (#{stats.okPerc}%)")
        Dom.div({className: 'bad'},
          "#{stats.bad} bad (#{stats.badPerc}%)")
        Dom.div({className: 'elapsed-time'}, stats.time, ' seconds')
      ]
      Dom.a({href: '/', className: 'ilink'}, 'Show wordlists ')
    ]


module.exports = UserPanel
