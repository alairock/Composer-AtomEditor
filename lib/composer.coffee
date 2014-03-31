fs = require 'fs'
path = require 'path'
{spawn} = require 'child_process'

ComposerView = require './composer-view'

module.exports =
    configDefaults:
        composerExecutablePath: '/usr/local/bin/composer'

    activate: ->
      atom.workspaceView.command "composer:update", => @update()
      atom.workspaceView.command "composer:init", => @init()

    update: ->
        command = 'update'
        @runner(command)

    init: ->
        command = 'init'
        @runner(command)

    runner: (command, options) ->
        composerPanel = atom.workspaceView.find(".composer-container")
        atom.workspaceView.prependToBottom new ComposerView unless composerPanel.is(":visible")

        projectPath = atom.project.getPath()
        composer = atom.config.get "composer.composerExecutablePath"
        tail = spawn(composer, [command + ' -d ' + projectPath])

        tail.stdout.on "data", (data) =>
            data = @replacenl(data)
            @writeToPanel(data)

        tail.stderr.on "data", (data) ->
            console.log "stderr: " + data

        tail.on "close", (code) =>
            @writeToPanel "<br>Complete<br>"
            console.log "child process exited with code " + code

    writeToPanel: (data) ->
        atom.workspaceView.find(".composer-container").append("#{data}").scrollToBottom()

    replacenl: (replaceThis) ->
        breakTag = "<br>"
        data = (replaceThis + "").replace /([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, "$1" + breakTag + "$2"
        return data
