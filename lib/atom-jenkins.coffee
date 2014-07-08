AtomJenkinsView = require './jenkins-view'

module.exports =
  activate: ->
    @view = new AtomJenkinsView()
    atom.packages.once 'activated', @view.attach

  deactivate: ->
    @atomJenkinsView.destroy()
