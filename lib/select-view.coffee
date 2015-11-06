{SelectListView} = require 'atom-space-pen-views'

module.exports =
  class MySelectListView extends SelectListView
   initialize: ->
     super
     @addClass('overlay from-top')
     @setItems(['Hello', 'World'])
     @panel ?= atom.workspace.addModalPanel(item: this)
     @panel.show()
     @focusFilterEditor()

   viewForItem: (item) ->
     "<li>#{item}</li>"

   confirmed: (item) ->
     console.log("#{item} was selected")

   cancelled: ->
     console.log("This view was cancelled")
     @panel.hide()
