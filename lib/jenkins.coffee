https = require('https')
Q = require('q')
extend = require('extend')
_ = require('underscore')

module.exports =
class Jenkins
  constructor: (hostname, username, token) ->
    @options =
      hostname: hostname
      port: 443
      auth: "#{username}:#{token}"

  # ======================================================================
  # Request Methods
  # ======================================================================

  request: (method, path) ->
    deferred = Q.defer()
    options = extend {}, @options,
      method: method,
      path: path

    https.request options, (err, rest...) ->
      console.log 'response', err, rest...
      if err deferred.reject(err)
      else   deferred.resolve(rest...)

    return deferred.promise

  get:  (path) => @request 'GET',  path
  post: (path) => @request 'POST', path
  put:  (path) => @request 'PUT',  path

  # ======================================================================
  # API Methods
  # ======================================================================

  job: (name) =>
    @get '/api/json?tree=jobs[name,url,color]'
      .then (rest...) => console.log '[job-then]:', rest...,
            (err) => console.log '[job-err]:', err
