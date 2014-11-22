$ = require('jquery')
parse = require('route-parser')

window.onpopstate = (event) ->
  console.log(event)
  go(event.state.url, true)

routes = []

parseRoute = (route) ->
  route

findRoute = (urlWithParams) ->
  for route in routes
    console.log(route)
    args = route.route.match(urlWithParams)
    console.log(args)
    return {title: route.title, args: args, callback: route.callback} if args

  throw Error("No matching Route for: #{urlWithParams}")

go = (url, isBack) ->
  console.log(url)
  {title, callback, args} = findRoute(url)
  console.log {title, callback, args}
  callback(args)
  history.pushState({url: url, args: args}, title, url) unless isBack
  document.title = title

addRoute = (url, title, callback) ->
  routes.push { url: url, route: parse(url), title: title, callback: callback}

start = ->
  $('body').on 'click', 'a', (e) ->
    e.preventDefault()
    console.log(e)
    go($(e.currentTarget).attr('href'))
  console.log('start called')

module.exports = {
  go: go
  addRoute: addRoute
  start: start
}
