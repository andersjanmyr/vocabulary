React = require 'react'

MessagePanel = require './message-panel'
Auth = require './auth'
Router = require './router'
Service = require './service'

Dom = React.DOM

QuizPanel = React.createFactory React.createClass
  render: ->
    Dom.form {id: 'quiz-panel'}, [
      Dom.div {id: 'quiz-word-panel'}, [
        Dom.div({id: 'quiz-word'},  this.props.pair[0])
        Dom.input({id: 'quiz-reply', type: 'text', ref: 'reply'})
      ]
      Dom.div({id: 'quiz-feedback'}, [
        Dom.div({id: 'quiz-feedback-word'}, 'Pending word')
        Dom.div({id: 'quiz-feedback-icon'}, 'Pending icon')
      ])
    ]

  componentDidMount: ->
    this.refs.reply.getDOMNode().focus()


module.exports = React.createFactory React.createClass
  getInitialState: ->
    {
      words: $.extend(true, {}, this.props.wordlist.words)
      replies: []
      currentIndex: 0
    }


  cancelClicked: (e) ->
    e.preventDefault()
    Router.go('/wordlists')


  currentPair: ->
    this.state.words[this.state.currentIndex]

  replyEntered: (reply) ->
    this.state.replies.push(reply)
    this.state.words.push(this.currentPair()) if this.currentPair()[1] isnt reply


  render: ->
    Dom.div {id: 'quiz'}, [
      Dom.h1({ id: 'quiz-name'}, "Quiz: #{this.props.wordlist.name}")
      Dom.span({className: 'lang'}, this.props.wordlist.lang1),
      ' to ',
      Dom.span({className: 'lang'}, this.props.wordlist.lang2),
      QuizPanel({
        pair: this.currentPair(),
        replyEntered: this.replyEntered
      })
    ]

