
Auth = {

  ownedByCurrentUser: (email) ->
    window.user.email is email

  currentUser: window.user and window.user.email
}


module.exports = Auth
