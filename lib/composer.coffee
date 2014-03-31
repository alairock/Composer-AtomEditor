fs = require 'fs'
path = require 'path'
{spawn} = require 'child_process'

ComposerView = require './composer-view'

module.exports =
    configDefaults:
        composerExecutablePath: '/usr/local/bin/composer'

    activate: ->
      atom.workspaceView.command "composer:update", => @update()
      atom.workspaceView.command "composer:friend", => @friend()

    update: ->
        composerPanel = atom.workspaceView.find(".composer-container")
        atom.workspaceView.prependToBottom new ComposerView unless composerPanel.is(":visible")

        projectPath = atom.project.getPath()
        command = atom.config.get "composer.composerExecutablePath"
        tail = spawn(command, ['update -d ' + projectPath])

        tail.stdout.on "data", (data) ->
            breakTag = "<br>"
            data = (data + "").replace /([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, "$1" + breakTag + "$2"
            atom.workspaceView.find(".composer-container").append("#{data}")
            atom.workspaceView.find(".composer-container").scrollToBottom()

        tail.stderr.on "data", (data) ->
            console.log "stderr: " + data

        tail.on "close", (code) ->
            atom.workspaceView.find(".composer-container").append("<br>To close this window: Press ctrl+p then press x ")
            atom.workspaceView.find(".composer-container").scrollToBottom()
            console.log "child process exited with code " + code

    friend: ->
        console.log "hello"
