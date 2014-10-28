{requirePackages} = require 'atom-utils'
TreeViewOpenFilesView = require './tree-view-open-files-view'

module.exports =
	TreeViewOpenFilesView: null

	activate: (state) ->
		requirePackages('tree-view').then ([treeView]) =>
			treeView.treeView.find('.tree-view-scroller').css 'background', treeView.treeView.find('.tree-view').css 'background'
			@TreeViewOpenFilesView = new TreeViewOpenFilesView(state.TreeViewOpenFilesViewState)
			@TreeViewOpenFilesView.toggle()

	deactivate: ->
		@TreeViewOpenFilesView.destroy()

	serialize: ->
		#TreeViewOpenFilesViewState: @TreeViewOpenFilesView.serialize()
