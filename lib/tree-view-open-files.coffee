{requirePackages} = require 'atom-utils'
TreeViewOpenFilesView = require './tree-view-open-files-view'

module.exports =
	treeViewOpenFilesView: null

	activate: (state) ->
		requirePackages('tree-view').then ([treeView]) =>
			@treeViewOpenFilesView = new TreeViewOpenFilesView

			if treeView.treeView
				@treeViewOpenFilesView.show()

			workspaceView = atom.views.getView(atom.workspace)

			atom.commands.add workspaceView, 'tree-view:toggle', =>
				if treeView.treeView.is(':visible')
					@treeViewOpenFilesView.show()
				else
					@treeViewOpenFilesView.hide()

			atom.commands.add workspaceView, 'tree-view:show', =>
				@treeViewOpenFilesView.show()

	deactivate: ->
		@treeViewOpenFilesView.destroy()

	serialize: ->
		#TreeViewOpenFilesViewState: @TreeViewOpenFilesView.serialize()
