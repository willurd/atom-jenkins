{View} = require 'atom'

module.exports =
class JenkinsView extends View
  @content: ->
    @div class: 'inline-block', =>
      @span outlet: 'status', 'Bob'

  initialize: (serializeState) ->
    atom.workspaceView.command "atom-jenkins:toggle", @toggle
    @attach()

  attach:  => atom.workspaceView.statusBar?.appendLeft(@)
  destroy: => @detach()
  toggle:  => if @hasParent() then @detach() else @attach()
