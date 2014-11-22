
Auth = {

  ownedByCurrentUser: (email) ->
    window.user.email is email

  owner: window.user.email
}


module.exports = Auth
