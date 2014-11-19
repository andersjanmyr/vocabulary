
MessagePanel = {

  show: (type, text) ->
    message = document.getElementById('message')
    message.className = type
    message.innerHTML = text
    setTimeout(
        -> message.className = ''; message.innerHTML = ''
        3000)

  showInfo: (text) ->
    @show('info', text)

  showError: (text) ->
    @show('error', text)
}

module.exports = MessagePanel
