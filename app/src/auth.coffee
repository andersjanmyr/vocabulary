
Auth = {

  ownedByCurrentUser: (email) ->
    window.user.email is email

}


module.exports = Auth
