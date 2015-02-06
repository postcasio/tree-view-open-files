{CompositeDisposable} = require 'event-kit'
_ = require 'lodash'
{$} = require 'space-pen'

module.exports =
class TreeViewOpenFilesPaneView
	constructor: ->
		@items = []
		@activeItem = null
		@paneSub = new CompositeDisposable

		@element = document.createElement('ul')
		@element.classList.add('list-tree', 'has-collapsable-children')
		nested = document.createElement('li')
		nested.classList.add('list-nested-item', 'expanded')
		@container = document.createElement('ul')
		@container.classList.add('list-tree')
		header = document.createElement('div')
		header.classList.add('list-item')

		headerSpan = document.createElement('span')
		headerSpan.classList.add('name', 'icon', 'icon-file-directory')
		headerSpan.setAttribute('data-name', 'Pane')
		headerSpan.innerText = 'Pane'
		header.appendChild headerSpan
		nested.appendChild header
		nested.appendChild @container
		@element.appendChild nested

		$(@element).on 'click', '.list-nested-item > .list-item', ->
			nested = $(this).closest('.list-nested-item')
			nested.toggleClass('expanded')
			nested.toggleClass('collapsed')
		self = this
		$(@element).on 'click', '.list-item[is=tree-view-file]', ->
			self.pane.activateItem self.entryForElement(this).item


	setPane: (pane) ->
		@pane = pane

		@paneSub.add pane.observeItems (item) =>
			listItem = document.createElement('li')
			listItem.classList.add('file', 'list-item')
			listItem.setAttribute('is', 'tree-view-file')
			closer = document.createElement('button')
			closer.classList.add('close-open-file')
			$(closer).on 'click', =>
				pane.destroyItem @entryForElement(listItem).item
			listItem.appendChild closer
			listItemName = document.createElement('span')
			listItemName.classList.add('name', 'icon', 'icon-file-text')
			listItemName.setAttribute('data-path', item.getPath?())
			listItemName.setAttribute('data-name', item.getTitle?())
			listItem.appendChild listItemName
			@container.appendChild listItem
			if item.onDidChangeTitle?
				titleSub = item.onDidChangeTitle =>
					@updateTitle item

				@paneSub.add titleSub
			if item.onDidChangeModified?
				@paneSub.add item.onDidChangeModified (modified) =>
					@updateModifiedState item, modified

			@items.push item: item, element: listItem
			@updateTitle item

		@paneSub.add pane.observeActiveItem (item) =>
			@setActiveEntry item

		@paneSub.add pane.onDidRemoveItem ({item}) =>
			@removeEntry item

		@paneSub.add pane.onDidDestroy => @paneSub.dispose()

	updateTitle: (item, siblings=true, useLongTitle=false) ->
		title = item.getTitle()

		if siblings
			for entry in @items
				if entry.item isnt item and entry.item.getTitle?() == title
					useLongTitle = true
					@updateTitle entry.item, false, true


		if useLongTitle and item.getLongTitle?
			title = item.getLongTitle()

		if entry = @entryForItem(item)
			$(entry.element).find('.name').text title

	updateModifiedState: (item, modified) ->
		entry = @entryForItem(item)

		entry?.element.classList.toggle 'modified', modified

	entryForItem: (item) ->
		_.detect @items, (entry) -> entry.item is item

	entryForElement: (item) ->
		_.detect @items, (entry) -> entry.element is item

	setActiveEntry: (item) ->
		if item
			@activeEntry?.classList.remove 'selected'
			if entry = @entryForItem item
				entry.element.classList.add 'selected'
				@activeEntry = entry.element

	removeEntry: (item) ->
		index = _.findIndex @items, (entry) -> entry.item is item

		if index >= 0
			@items[index].element.remove()
			@items.splice index, 1

		@updateTitle(entry.item) for entry in @items

	# Returns an object that can be retrieved when package is activated
	serialize: ->

	# Tear down any state and detach
	destroy: ->
		@element.remove()
		@paneSub.dispose()
