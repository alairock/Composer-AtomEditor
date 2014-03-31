{View} = require 'atom'

module.exports =
# Internal: The main view for displaying the status from Travis CI.
class ComposerView extends View
  # Internal: Build up the HTML contents for the fragment.
  @content: ->
    @div class: "composer-container"


  initialize: ->
    atom.workspaceView.command "composer:destroy", => @destroy()

  # Internal: Destroy the view and tear down any state.
  #
  # Returns nothing.
  destroy: ->
    if @isVisible()
      @detach()
