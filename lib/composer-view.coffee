{View} = require 'atom'

module.exports =
class ComposerView extends View
  @content: ->
    @div class: 'composer overlay from-top', =>
      @div "The Composer package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "composer:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "ComposerView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
