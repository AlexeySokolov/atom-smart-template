AtomSmartTemplateView = require './atom-smart-template-view'
{CompositeDisposable} = require 'atom'
path   = require 'path'
fsPlus = require 'fs-plus'
_      = require 'underscore'
fs     = require 'fs'

module.exports = AtomSmartTemplate =
  atomSmartTemplateView: null
  modalPanel: null
  subscriptions: null
  templatesRoot: null

  activate: (state) ->

    @templatesRoot = path.join atom.getUserInitScriptPath(), '../', 'smart-templates'

    fsPlus.makeTreeSync(@templatesRoot)

    @atomSmartTemplateView = new AtomSmartTemplateView(state.atomSmartTemplateViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @atomSmartTemplateView.getElement(), visible: false)

    @subscriptions = new CompositeDisposable

    # Command register
    @subscriptions.add atom.commands.add '.tree-view .selected', 'atom-smart-template:create-files-from-template', (e) => @createFilesFromTemplate(e)

    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-smart-template:open-temlates-folder', (e) => @openTemplatesFolder(e)

    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-smart-template:open-temlates-folder-in-atom', (e) => @openTemplatesFolderInAtom(e)

    # Scan templatesRoot

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


  createFilesFromTemplate: (e) ->
    itemPath = e.currentTarget?.getPath?() ? target.getModel?().getPath()
    newFile = path.join itemPath, "tmp/1/2/3/hello.txt"
    fsPlus.makeTreeSync(path.dirname(newFile))
    fs.writeFileSync(newFile, "This is generated data 1")

    # if @modalPanel.isVisible()
    #   @modalPanel.hide()
    # else
    #   @modalPanel.show()
