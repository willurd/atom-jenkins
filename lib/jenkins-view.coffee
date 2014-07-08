{View, $} = require 'atom'
Jenkins = require './jenkins'
fs = require('fs')
path = require('path')
shell = require('shell')

module.exports =
class JenkinsView extends View
  @content: ->
    @div class: 'atom-jenkins inline-block', =>
      @a class: 'job status none', outlet: 'status', '(Jenkins)'

  initialize: ->
    # TODO: This is just temporary.
    config = JSON.parse(fs.readFileSync(path.join(atom.project.path, '.atom-jenkins')).toString())
    {hostname, username, password, job} = config

    @baseUrl = "https://#{hostname}"

    @jenkins = new Jenkins(hostname, username, password)
    @jenkins.job(job).then @updateJob, (err) =>
      console.error "Unable to load information for job '#{job}': #{error}"

    @status.on 'click', @onJobClick

    atom.workspaceView.command "atom-jenkins:toggle", @toggle
    @attach()

  attach:  => atom.workspaceView.statusBar?.appendLeft(@)
  destroy: => @detach()
  toggle:  => if @hasParent() then @detach() else @attach()

  open: (path) => shell.openExternal("#{@baseUrl}/#{path}")

  updateJob: (job) =>
    @status.text job.name
    @status.attr 'href', '#'
    @status.data 'job', job
    @status.removeClass 'none'
    @status.removeClass @jenkins.statuses
    @status.addClass "status-#{job.color}"

  onJobClick: (event) =>
    $el = $(event.target)
    job = $el.data 'job'
    @open "job/#{job.name}/"
