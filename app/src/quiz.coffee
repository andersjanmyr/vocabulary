React = require 'react'

_ = require('lodash')
MessagePanel = require './message-panel'
Auth = require './auth'
Router = require './router'
Service = require './service'

Dom = React.DOM

DonePanel = React.createFactory React.createClass
  feedback: () ->
    stats = this.props.stats
    if stats.tries is stats.words
      {className: 'perfect', icon: ':D', word: 'Perfect!' }
    else if stats.tries < (stats.words * 1.5)
      {className: 'ok', icon: ':/', word: 'Not bad!' }
    else
      {className: 'bad', icon: ':(', word: 'Practice!' }

  onTryAgain: (e) ->
    e.preventDefault()
    this.props.reset()

  render: ->
    stats = this.props.stats
    console.log(stats)
    feedback = this.feedback()
    Dom.div {id: 'stats-panel'}, [
      Dom.div({id: 'quiz-left-panel'}, [
        Dom.h2({}, 'Stats')
        Dom.div({id: 'stats-words'}, stats.words, ' words')
        Dom.div({id: 'stats-tries'}, stats.tries, ' tries')
        Dom.div({className: 'wrong'}, stats.wrong, ' wrong')
        Dom.div({className: 'wrong-case'}, stats.wrongCase, ' wrong case')
        Dom.div({className: 'correct'}, stats.correct, ' correct')
        Dom.div({className: 'elapsed-time'}, stats.elapsedTime, ' seconds')
        Dom.a({href: '/wordlists', className: 'ilink'}, 'Show wordlists ')
        Dom.a({href: '#', onClick: this.onTryAgain}, 'Try again')
      ]),
      Dom.div({id: 'quiz-right-panel'}, [
        Dom.div({id: 'quiz-stats-icon', className: feedback.className}, feedback.icon)
        Dom.div({id: 'quiz-stats-word', className: feedback.className}, feedback.word)
      ])
    ]

QuizPanel = React.createFactory React.createClass
  getInitialState: ->
    {
      correct: ''
      feedbackClass: ''
      feedbackIcon: ''
      timeout: 1500
      errorTimeout: 2500
    }

  render: ->
    Dom.form {id: 'quiz-form', onSubmit: this.onSubmit}, [
      Dom.div {id: 'quiz-word-panel'}, [
        Dom.div({id: 'quiz-word'},  this.props.pair[0])
        Dom.input({id: 'quiz-reply', type: 'text', autocomplete: 'off', ref: 'reply'})
      ]
      Dom.div({id: 'quiz-feedback'}, [
        Dom.div({id: 'quiz-feedback-word', className: this.state.feedbackClass},
          this.state.correct)
        Dom.div({id: 'quiz-feedback-icon', className: this.state.feedbackClass},
          this.state.feedbackIcon)
      ]
      Dom.div {id: 'quiz-count-panel'}, [
        Dom.span({id: 'quiz-current'},  this.props.current)
        ' / '
        Dom.span({id: 'quiz-count'},  this.props.count)
      ])
    ]

  componentDidMount: ->
    this.refs.reply.getDOMNode().focus()

  feedbackValue: () ->
    feedbackClass = this.state.feedbackClass
    return 'wrongCase' if feedbackClass is 'wrong-case'
    feedbackClass

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
    timeout = if value is correct
      this.state.timeout
    else
      this.state.errorTimeout
    setTimeout(this.resultEntered.bind(this, this.feedbackValue()), timeout)

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
        words: this.props.wordlist.words.length
        tries: 0
        wrong: 0
        wrongCase: 0
        correct: 0
      }
      currentIndex: 0
      startTime: new Date()
    }


  currentPair: ->
    this.state.words[this.state.currentIndex]

  replyEntered: (result) ->
    this.state.stats[result]++
    console.log('result', result)
    if result isnt 'correct'
      this.state.words.push(this.currentPair())
    this.state.currentIndex++
    this.state.stats.tries = this.state.currentIndex
    if this.done()
      this.state.stats.elapsedTime = (new Date() - this.state.startTime)/1000
    this.setState(this.state)

  done: ->
    this.state.currentIndex >= this.state.words.length

  reset: ->
    this.setState(this.getInitialState())

  render: ->
    Dom.div {id: 'quiz'}, [
      Dom.h1({ id: 'quiz-name'}, "Quiz: #{this.props.wordlist.name}")
      Dom.span({className: 'lang'}, this.props.wordlist.lang1),
      ' to ',
      Dom.span({className: 'lang'}, this.props.wordlist.lang2),
      Dom.div {id: 'quiz-panel'}, [
        if this.done()
          Service.saveStats this.state.stats, (err, result) ->
            console.log(err, result)
          DonePanel(stats: this.state.stats, reset: this.reset)
        else
          QuizPanel({
            pair: this.currentPair(),
            count: this.state.words.length,
            current: this.state.currentIndex+1,
            replyEntered: this.replyEntered
          })
      ]
    ]

