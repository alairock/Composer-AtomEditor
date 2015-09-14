Composer = require './composer'

module.exports =

  config:
    composerPath:
      default: 'composer'
      title: 'Path to composer executable'
      type: 'string'

    installExtraArgs:
      default: []
      description: 'Comma-separated list of extra args for the install command'
      items:
        type: 'string'
      type: 'array'

    updateExtraArgs:
      default: []
      description: 'Comma-separated list of extra args for the update command'
      items:
        type: 'string'
      type: 'array'

  activate: (state) ->
    @composer ?= new Composer

    names = [
      'about'
      'archive'
      'clear-cache'
      'dump-autoload'
      'install'
      'self-update'
      'update'
      'validate'
      'version'
    ]

    commands = []

    names.forEach (name) =>
      command = "composer:#{name}"
      commands[command] = =>
        @composer[name].apply @composer

    @commandDisposable = atom.commands.add 'atom-workspace', commands

  deactivate: ->
    @commandDisposable?.dispose()
    @composer?.destructor()
    delete @commandDisposable
    delete @composer
