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

  _run: (command, args...) ->
    closeOnComplete = atom.config.get 'composer.closeOnComplete'
    composerPath = atom.config.get 'composer.composerPath'
    firstRun = true
    [projectPath, ...] = atom.project.getPaths()

    projectPath ?= atom.config.get 'core.projectHome' or
      fs.getHomeDirectory()

    args = [command, '-d', projectPath, '-n', args...]
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
    installExtraArgs = atom.config.get 'composer.installExtraArgs'
    @_run 'install', installExtraArgs...

  'self-update': ->
    @_run 'self-update'

  update: ->
    updateExtraArgs = atom.config.get 'composer.updateExtraArgs'
    @_run 'update', updateExtraArgs...

  validate: ->
    @_run 'validate'

module.exports = Composer
