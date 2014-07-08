{View} = require 'atom'
Jenkins = require './jenkins'
fs = require('fs')
path = require('path')

module.exports =
class JenkinsView extends View
  @content: ->
    @div class: 'atom-jenkins inline-block', =>
      @span class: 'job status', outlet: 'status', '(Jenkins)'

  initialize: ->
    # TODO: This is just temporary.
    config = JSON.parse(fs.readFileSync(path.join(atom.project.path, '.atom-jenkins')).toString())
    {hostname, username, password, job} = config

    @jenkins = new Jenkins(hostname, username, password)
    @jenkins.job(job).then @updateJob, (err) =>
      console.error "Unable to load information for job '#{job}': #{error}"

    atom.workspaceView.command "atom-jenkins:toggle", @toggle
    @attach()

  attach:  => atom.workspaceView.statusBar?.appendLeft(@)
  destroy: => @detach()
  toggle:  => if @hasParent() then @detach() else @attach()

  updateJob: (job) =>
    @status.text job.name
    @status.removeClass @jenkins.statuses
    @status.addClass "status-#{job.color}"
