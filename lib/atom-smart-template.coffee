SelectView = require './select-view'
{CompositeDisposable} = require 'atom'
path   = require 'path'
fsPlus = require 'fs-plus'
_      = require 'underscore'
fs     = require 'fs'
ejs    = require 'ejs'
$      = require 'jquery'

module.exports = AtomSmartTemplate =
  atomSmartTemplateView: null
  modalPanel: null
  subscriptions: null
  templatesRoot: null

  activate: (state) ->

    @templatesRoot = path.join atom.getUserInitScriptPath(), '../', 'smart-templates'

    fsPlus.makeTreeSync(@templatesRoot)

    @subscriptions = new CompositeDisposable

    # Command register
    @subscriptions.add atom.commands.add '.tree-view .selected', 'atom-smart-template:create-files-from-template', (e) => @createFilesFromTemplate(e)

    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-smart-template:open-temlates-folder', (e) => @openTemplatesFolder(e)

    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-smart-template:open-temlates-folder-in-atom', (e) => @openTemplatesFolderInAtom(e)

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomSmartTemplateView.destroy()

  serialize: ->
    atomSmartTemplateViewState: @atomSmartTemplateView.serialize()

  openTemplatesFolder: (e) ->
    require('child_process').exec "open #{@templatesRoot}"

  openTemplatesFolderInAtom: (e) ->
    require('child_process').exec "open -a Atom.app #{@templatesRoot}"
    console.log "atom #{@templatesRoot}"

  scanTemplatesFolder: ->

    templates = []

    for item in (fs.readdirSync(@templatesRoot))

      fullPathToFolder = path.join @templatesRoot, item
      continue unless fsPlus.isDirectorySync(fullPathToFolder)

      fullPathToIndexIndex = path.join fullPathToFolder, "index.js"
      continue unless fsPlus.isFileSync(fullPathToIndexIndex)

      try
        delete require.cache[fullPathToIndexIndex]
        templateObject = require(fullPathToIndexIndex)
        templateObject.rootPath = fullPathToFolder 
        continue unless templateObject.name
        continue unless templateObject.template
        templates.push templateObject

    return templates

  createFilesFromTemplate: (e) ->

    itemPath = e.currentTarget?.getPath?() ? target.getModel?().getPath()

    selectView = new SelectView(itemPath, @scanTemplatesFolder())

    # newFile  = path.join itemPath, "tmp/1/2/3/hello.txt"
    # fsPlus.makeTreeSync(path.dirname(newFile))
    # fs.writeFileSync(newFile, "This is generated data 1")
