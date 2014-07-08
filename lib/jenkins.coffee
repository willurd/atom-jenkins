https = require('https')
Q = require('q')
extend = require('extend')
_ = require('underscore')

baseColors = [
  'red', # Failed
  'yellow',
  'blue', # Success
  'grey',
  'disabled', # Disabled
  'aborted', # Aborted
  'nobuilt'
]
colors = baseColors.concat(baseColors.map (color) -> "#{color}_anime")

module.exports =
class Jenkins
  colors: colors
  statuses: colors.map (color) -> "status-#{color}"

  constructor: (hostname, username, password) ->
    @options =
      hostname: hostname
      auth: "#{username}:#{password}"
      agent: false

  # ======================================================================
  # Request Methods
  # ======================================================================

  request: (method, path) ->
    deferred = Q.defer()
    options = extend {}, @options,
      method: method,
      path: path
    result = ''

    req = https.request options, (res) ->
      res.on 'data', (chunk) -> result += chunk.toString()
      res.on 'end', -> deferred.resolve(JSON.parse(result))

    req.on 'error', deferred.reject
    req.end()

    return deferred.promise

  get:  (path) => @request 'GET',  path
  post: (path) => @request 'POST', path
  put:  (path) => @request 'PUT',  path

  # ======================================================================
  # API Methods
  # ======================================================================

  job: (name) =>
    @get '/api/json?tree=jobs[name,url,color]'
      .then (result) =>
        _.find result.jobs, (job) -> job.name == name
      , (err) =>
        console.log '[job-err]:', err
