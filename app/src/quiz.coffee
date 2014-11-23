React = require 'react'

_ = require('lodash')
MessagePanel = require './message-panel'
Auth = require './auth'
Router = require './router'
Service = require './service'

Dom = React.DOM

DonePanel = React.createFactory React.createClass
  render: ->
    Dom.div {id: 'done-panel'}, [
      'Done'
    ]

QuizPanel = React.createFactory React.createClass
  getInitialState: ->
    {
      correct: ''
      feedbackClass: ''
      feedbackIcon: ''
      timeout: 1500
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
    setTimeout(this.resultEntered.bind(this, this.state.feedbackClass), this.state.timeout)

  resultEntered: (result) ->
    this.refs.reply.getDOMNode().value = ''
    this.refs.reply.getDOMNode().focus()
    this.state.correct = ''
    this.state.feedbackClass = ''
    this.state.feedbackIcon = ''
    this.props.replyEntered(result)


module.exports = React.createFactory React.createClass
  getInitialState: ->
    {
      words: _.shuffle(this.props.wordlist.words)
      stats: {
        'wrong': 0
        'wrong-case': 0
        'correct': 0
      }
      currentIndex: 0
    }


  cancelClicked: (e) ->
    e.preventDefault()
    Router.go('/wordlists')


  currentPair: ->
    this.state.words[this.state.currentIndex]

  replyEntered: (result) ->
    this.state.stats[result]++
    this.state.words.push(this.currentPair()) if result isnt 'correct'
    this.state.currentIndex++
    this.setState(this.state)

  done: ->
    this.state.currentIndex >= this.state.words.length

  render: ->
    Dom.div {id: 'quiz'}, [
      Dom.h1({ id: 'quiz-name'}, "Quiz: #{this.props.wordlist.name}")
      Dom.span({className: 'lang'}, this.props.wordlist.lang1),
      ' to ',
      Dom.span({className: 'lang'}, this.props.wordlist.lang2),
      if this.done()
        DonePanel()
      else
        QuizPanel({
          pair: this.currentPair(),
          replyEntered: this.replyEntered
        })
    ]

