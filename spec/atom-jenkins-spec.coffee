{WorkspaceView} = require 'atom'
AtomJenkins = require '../lib/atom-jenkins'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "AtomJenkins", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('atom-jenkins')

  describe "when the atom-jenkins:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.atom-jenkins')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'atom-jenkins:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.atom-jenkins')).toExist()
        atom.workspaceView.trigger 'atom-jenkins:toggle'
        expect(atom.workspaceView.find('.atom-jenkins')).not.toExist()
