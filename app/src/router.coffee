
routes = {}

go = (url, title) ->
  history.pushState({}, title, url)
  routes[url]()

addRoute = (url, callback) ->
  routes[url] = callback

start = ->
  console.log('start called')

module.exports = {
  go: go
  addRoute: addRoute
  start: start
}
