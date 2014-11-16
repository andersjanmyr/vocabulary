React = require 'react'

Dom = React.DOM
module.exports = React.createClass
    render: ->
        Dom.div {id: 'header'}, [
            Dom.div {id: 'logo'}, [
                Dom.img { src: '/images/victory-128.png'}
                Dom.h1 { id: 'headline'}, 'ocabulary'
            ],
            Dom.div {id: 'login'}, [
                Dom.div { id: 'email'}, null
                Dom.div { id: 'password'}, null
            ],

        ]



