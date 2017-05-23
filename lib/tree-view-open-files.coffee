{requirePackages} = require 'atom-utils'
TreeViewOpenFilesView = require './tree-view-open-files-view'

module.exports =
	treeViewOpenFilesView: null

	config:
		maxHeight:
			type: 'integer'
			default: 250
			min: 0
			description: 'Maximum height of the list before scrolling is required. Set to 0 to disable scrolling.'

	activate: (state) ->
		requirePackages('tree-view').then ([treeView]) =>
			@treeViewOpenFilesView = new TreeViewOpenFilesView(treeView)

			if treeView.treeView
				@treeViewOpenFilesView.show()

			atom.commands.add 'atom-workspace', 'tree-view:toggle', =>
				@treeViewOpenFilesView.toggle()

			atom.commands.add 'atom-workspace', 'tree-view:show', =>
				@treeViewOpenFilesView.show()

	deactivate: ->
		@treeViewOpenFilesView.destroy()

	serialize: ->
