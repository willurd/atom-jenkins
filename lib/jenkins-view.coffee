{View} = require 'atom'
Jenkins = require './jenkins'
fs = require('fs')
path = require('path')

module.exports =
class JenkinsView extends View
  @content: ->
    @div class: 'inline-block', =>
      @span outlet: 'status', 'Jenkins'

  initialize: ->
    # TODO: This is just temporary.
    config = JSON.parse(fs.readFileSync(path.join(atom.project.path, '.atom-jenkins')).toString())
    {hostname, username, token} = config

    @jenkins = new Jenkins(hostname, username, token)
    @jenkins.job 'staging-qa'
      .then (rest...) => console.log '[job] success: #{rest}',
            (error) => console.log '[job] error: #{error}'

    atom.workspaceView.command "atom-jenkins:toggle", @toggle
    @attach()

  attach:  => atom.workspaceView.statusBar?.appendLeft(@)
  destroy: => @detach()
  toggle:  => if @hasParent() then @detach() else @attach()
