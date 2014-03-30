ComposerView = require './composer-view'

module.exports =
  composerView: null

  activate: (state) ->
    @composerView = new ComposerView(state.composerViewState)

  deactivate: ->
    @composerView.destroy()

  serialize: ->
    composerViewState: @composerView.serialize()
