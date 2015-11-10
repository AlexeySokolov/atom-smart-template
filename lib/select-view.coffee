_                                = require 'underscore'
path                             = require 'path'
fsPlus                           = require 'fs-plus'
fs                               = require 'fs'
ejs                              = require 'ejs'
{View, $}                        = require 'space-pen'
{SelectListView, TextEditorView} = require 'atom-space-pen-views'


class ParamSelectView extends View

  initialize: (@itemPath, @template)->

    atom.commands.add @element,
      'core:confirm': => @onConfirm()
      'core:cancel': => @destroy()


    @createButton.on 'click', =>
      @onConfirm()

    @cancelButton.on 'click', =>
      @destroy()  


  attach: ->
    @panel = atom.workspace.addModalPanel(item: this)
    # @miniEditor.focus()

  destroy: ->
    @panel.destroy()
    atom.workspace.getActivePane().activate()

  onConfirm: ->
    console.log "onConfirm", @itemPath, @template
    do @destroy


  @content: (itemPath, template) ->
    @div class: 'overlay from-top', =>
      @h4 'New files by template: ' + template.name

      for param in (template.params ? [])
        @label param
        @subview param + 'Editor', new TextEditorView(mini: true)

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
