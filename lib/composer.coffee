ComposerView = require './composer-view'

module.exports =
  composerView: null

  activate: (state) ->
    @composerView = new ComposerView(state.composerViewState)
    alert "activated"

  deactivate: ->
    @composerView.destroy()

  serialize: ->
    composerViewState: @composerView.serialize()
