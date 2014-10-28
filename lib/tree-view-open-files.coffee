{requirePackages} = require 'atom-utils'
TreeViewOpenFilesView = require './tree-view-open-files-view'

module.exports =
	TreeViewOpenFilesView: null

	activate: (state) ->
		requirePackages('tree-view').then ([treeView]) =>
			@TreeViewOpenFilesView = new TreeViewOpenFilesView(state.TreeViewOpenFilesViewState)
			@TreeViewOpenFilesView.toggle()

	deactivate: ->
		@TreeViewOpenFilesView.destroy()

	serialize: ->
		#TreeViewOpenFilesViewState: @TreeViewOpenFilesView.serialize()
