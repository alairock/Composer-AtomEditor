fs = require 'fs'
{LineStream} = require 'byline'
{MessagePanelView, PlainMessageView} = require 'atom-message-panel'
spawn = require 'cross-spawn'
strs = require 'stringstream'

class Composer

  constructor: ->
    @view ?= new MessagePanelView
      title: 'Composer'

  destructor: ->
    @view.close()
    @view.remove()
    delete @view

  _run: (command) ->
    closeOnComplete = atom.config.get 'composer.closeOnComplete'
    composerPath = atom.config.get 'composer.composerPath'
    composerArgs = atom.config.get 'composer.composerArgs'
    firstRun = true
    [projectPath, ...] = atom.project.getPaths()

    projectPath ?= atom.config.get 'core.projectHome' or
      fs.getHomeDirectory()

    if command == 'install' || command == 'update'
      args = [command, '-d', projectPath, composerArgs]
    else
      args = [command, '-d', projectPath]

    childProcess = spawn composerPath, args
    stdout = childProcess.stdout
    stderr = childProcess.stderr

    onData = (data) =>
      if firstRun
        @view.clear()
        firstRun = false

      @view.attach()

      if ~data.indexOf 'Downloading:'
        [..., message] = @view.messages
        return if message.message is 'Downloading...'

        @view.add new PlainMessageView
          message: 'Downloading...'

      else
        [messages..., last] = @view.messages
        if last?.message is 'Downloading...'
          @view.clear()
          @view.add message for message in messages
          @view.add new PlainMessageView
            message: 'Download complete.'

        @view.add new PlainMessageView
          message: data

    stdout.pipe new LineStream
      .pipe strs 'utf8'
      .on 'data', onData

    stderr.pipe new LineStream
      .pipe strs 'utf8'
      .on 'data', onData

  about: ->
    @_run 'about'

  archive: ->
    @_run 'archive'

  'clear-cache': ->
    @_run 'clear-cache'

  'dump-autoload': ->
    @_run 'dump-autoload'

  install: ->
    @_run 'install'

  'self-update': ->
    @_run 'self-update'

  update: ->
    @_run 'update'

  validate: ->
    @_run 'validate'

module.exports = Composer
