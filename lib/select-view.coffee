_                                = require 'underscore'
path                             = require 'path'
fsPlus                           = require 'fs-plus'
fsExtra                          = require 'fs-extra'
fs                               = require 'fs'
{View, $}                        = require 'space-pen'
{SelectListView, TextEditorView} = require 'atom-space-pen-views'
{allowUnsafeEval, allowUnsafeNewFunction} = require 'loophole'


class ParamSelectView extends View

  initialize: (@targetPath, @template)->

    atom.commands.add @element,
      'core:confirm': => @onConfirm()
      'core:cancel': => @destroy()


    @createButton.on 'click', =>
      @onConfirm()

    @cancelButton.on 'click', =>
      @destroy()


  attach: ->
    @panel = atom.workspace.addModalPanel(item: this)
    for param in (@template.params ? [])
      @[param.name+"Editor"].setText(param.default)
    # @miniEditor.focus()

  destroy: ->
    @panel.destroy()
    atom.workspace.getActivePane().activate()

  onConfirm: ->

    cfg = {}
    nameParam = ''

    for param in (@template.params ? [])
      cfg[param.name] = @[param.name+"Editor"].getText()

      if param.name == 'Name' && @template.directory

        if cfg[param.name].length > 0
          nameParam = cfg[param.name].replace(/\s+/g, '-').toLowerCase()
        else
          nameParam = @template.name.replace(/\s+/g, '-').toLowerCase()

    for rule in ((@template.rules?(cfg).items) ? [])
      continue unless rule.destinationFile

      if rule.sourceContentFile
        fullPathToTemplateFile = path.join @template.rootPath, rule.sourceContentFile
        fullPathToNewFile      = path.join @targetPath, nameParam, rule.destinationFile
        try
          fsPlus.makeTreeSync( path.dirname(fullPathToNewFile) )
          fsExtra.copySync fullPathToTemplateFile, fullPathToNewFile
        catch error
          console.error  "Template processing error: #{error}"

      if rule.sourceTemplateFile
        fullPathToTemplateFile = path.join @template.rootPath, rule.sourceTemplateFile
        fullPathToNewFile      = path.join @targetPath, nameParam, rule.destinationFile

        try
          fsPlus.makeTreeSync( path.dirname(fullPathToNewFile) )
          t = fs.readFileSync(fullPathToTemplateFile, "utf8")
          allowUnsafeEval ->
            allowUnsafeNewFunction ->
              compiledTemplate = _.template(t)
              fs.writeFileSync(fullPathToNewFile, compiledTemplate(cfg) , "utf8")
        catch error
          console.error  "Template processing error: #{error}"






    do @destroy


  @content: (itemPath, template) ->
    @div class: 'overlay from-top', =>
      @h4 'New files by template: ' + template.name

      for param in (template.params ? [])
        @label param.name
        @subview param.name + 'Editor', new TextEditorView(mini: true)

      @button outlet: 'createButton', class: 'btn', 'Create'
      @button outlet: 'cancelButton', class: 'btn', 'Cancel'


module.exports =
  class MySelectListView extends SelectListView

   initialize: (@itemPath, @templates)->
     super

     @addClass('overlay from-top')
     @setItems(@templates)


     @panel ?= atom.workspace.addModalPanel(item: this)
     @panel.show()

     @focusFilterEditor()

   viewForItem: (item) ->
     "<li>#{item.name}</li>"

   confirmed: (item) ->
     @cancel()
     (new ParamSelectView(@itemPath, item)).attach()

   cancelled: ->
     @panel.hide()
     try
       @panel.destroy()
