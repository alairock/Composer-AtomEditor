{View} = require 'atom'

module.exports =
# Internal: The main view for displaying the status from Travis CI.
class ComposerView extends View
  # Internal: Build up the HTML contents for the fragment.
  @content: ->
    @div class: "composer-container", =>
      @div class: "composer-close-button", =>
        @text "Close"


  initialize: ->
    atom.workspaceView.command "composer:destroy", => @destroy()
    atom.workspaceView.find(".composer-close-button").on "click", ->
      console.log "Hello"

  # Internal: Destroy the view and tear down any state.
  #
  # Returns nothing.
  destroy: ->
    if @isVisible()
      @detach()
