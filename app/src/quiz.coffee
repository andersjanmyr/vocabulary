React = require 'react'

MessagePanel = require './message-panel'
Auth = require './auth'
Router = require './router'
Service = require './service'

Dom = React.DOM

QuizPanel = React.createFactory React.createClass
  getInitialState: ->
    {
      correct: ''
      feedbackClass: ''
      feedbackIcon: ''
    }

  render: ->
    Dom.form {id: 'quiz-panel', onSubmit: this.onSubmit}, [
      Dom.div {id: 'quiz-word-panel'}, [
        Dom.div({id: 'quiz-word'},  this.props.pair[0])
        Dom.input({id: 'quiz-reply', type: 'text', ref: 'reply'})
      ]
      Dom.div({id: 'quiz-feedback'}, [
        Dom.div({id: 'quiz-feedback-word', className: this.state.feedbackClass},
          this.state.correct)
        Dom.div({id: 'quiz-feedback-icon', className: this.state.feedbackClass},
          this.state.feedbackIcon)
      ])
    ]

  componentDidMount: ->
    this.refs.reply.getDOMNode().focus()

  onSubmit: (e) ->
    e.preventDefault()
    value = this.refs.reply.getDOMNode().value
    correct = this.props.pair[1]
    this.state.correct = correct
    if value is correct
      this.state.feedbackClass = 'correct'
      this.state.feedbackIcon = ':D'
    else if value.toLowerCase() is correct.toLowerCase()
      this.state.feedbackClass = 'wrong-case'
      this.state.feedbackIcon = ':/'
    else
      this.state.feedbackClass = 'wrong'
      this.state.feedbackIcon = ':('
    this.setState(this.state)




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

