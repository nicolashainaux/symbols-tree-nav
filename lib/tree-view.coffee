{$, $$, View, ScrollView} = require 'atom-space-pen-views'
{Emitter} = require 'event-kit'

module.exports =
  TreeNode: class TreeNode extends View
    @content: ({label, icon, children}) ->
      highLightClass = ''
      syntaxCategory = ''
      showIconsExceptions = atom.config.get('symbols-tree-nav.showIconsExceptions').split " "
      scopeName = atom.workspace.getActiveTextEditor()?.getGrammar()?.scopeName
      if scopeName?
        [first, ..., language] = scopeName.split "."
      else
        language = undefined
      if icon?
        [first, ..., syntaxCategory] = icon.split "-"
      if language in ['python', 'django'] and syntaxCategory == 'member'
        syntaxCategory = 'function'
      if atom.config.get('symbols-tree-nav.colorsFromSyntaxTheme')
        if syntaxCategory in ['function', 'method', 'class', 'variable', 'source', 'library']
          highLightClass = {
            'function' : "syntax--entity syntax--name syntax--function syntax--#{language}"
            'method'   : "syntax--entity syntax--name syntax--function syntax--#{language}"
            'class'    : "syntax--entity syntax--name syntax--type syntax--class syntax--#{language}"
            'variable' : "syntax--source syntax--#{language}"
            'source'   : "syntax--entity syntax--name syntax--function syntax--#{language}"
            'library'  : "syntax--keyword syntax--control syntax--import syntax--#{language}"
          }[syntaxCategory]
      iconClass = ""
      if atom.config.get('symbols-tree-nav.showIcons')
        if language not in showIconsExceptions
          iconClass = "icon #{icon}"
      else
        if language in showIconsExceptions
          iconClass = "icon #{icon}"
      customColorClass = ""
      if atom.config.get('symbols-tree-nav.customColors')
        if syntaxCategory != ''
            customColorClass = "custom-#{syntaxCategory}"
      minTitlesLength = atom.config.get('symbols-tree-nav.minTitlesLength')
      itemTitle = if minTitlesLength != -1 and label.length >= minTitlesLength then label else ''
      if children
        collapsed = if atom.config.get('symbols-tree-nav.collapsedByDefault') then " collapsed" else ""
        @li class: "list-nested-item list-selectable-item#{collapsed}", title: itemTitle, =>
          @div class: 'list-item', =>
            @span class: "#{customColorClass} #{iconClass} #{highLightClass}", label
          @ul class: 'list-tree', =>
            for child in children
              @subview 'child', new TreeNode(child)
      else
        @li class: 'list-item list-selectable-item', title: itemTitle, =>
          @span class: "#{customColorClass} #{iconClass} #{highLightClass}", label

    initialize: (item) ->
      @emitter = new Emitter
      @item = item
      @item.view = this

      @on 'dblclick', @dblClickItem
      @on 'click', @clickItem

    setCollapsed: ->
      @toggleClass('collapsed') if @item.children

    setSelected: ->
      @addClass('selected')

    onDblClick: (callback) ->
      @emitter.on 'on-dbl-click', callback
      if @item.children
        for child in @item.children
          child.view.onDblClick callback

    onSelect: (callback) ->
      @emitter.on 'on-select', callback
      if @item.children
        for child in @item.children
          child.view.onSelect callback

    clickItem: (event) =>
      if @item.children
        selected = @hasClass('selected')
        @removeClass('selected')
        $target = @find('.list-item:first')
        left = $target.position().left
        right = $target.children('span').position().left
        width = right - left
        @toggleClass('collapsed') if event.offsetX <= width
        @addClass('selected') if selected
        return false if event.offsetX <= width

      @emitter.emit 'on-select', {node: this, item: @item}
      return false

    dblClickItem: (event) =>
      @emitter.emit 'on-dbl-click', {node: this, item: @item}
      return false


  TreeView: class TreeView extends ScrollView
    @content: ->
      @div class: '-tree-view-', =>
        @ul class: 'list-tree has-collapsable-children', outlet: 'root'

    initialize: ->
      super
      @emitter = new Emitter

    deactivate: ->
      @remove()

    onSelect: (callback) =>
      @emitter.on 'on-select', callback

    setRoot: (root, ignoreRoot=true) ->
      @rootNode = new TreeNode(root)

      @rootNode.onDblClick ({node, item}) =>
        node.setCollapsed()
      @rootNode.onSelect ({node, item}) =>
        @clearSelect()
        node.setSelected()
        @emitter.emit 'on-select', {node, item}

      @root.empty()
      @root.append $$ ->
        @div =>
          if ignoreRoot
            for child in root.children
              @subview 'child', child.view
          else
            @subview 'root', root.view

    traversal: (root, doing) =>
      doing(root.item)
      if root.item.children
        for child in root.item.children
          @traversal(child.view, doing)

    toggleTypeVisible: (type) =>
      @traversal @rootNode, (item) =>
        if item.type == type
          item.view.toggle()

    sortByName: (ascending=true) =>
      @traversal @rootNode, (item) =>
        item.children?.sort (a, b) =>
          typeComp = atom.config.get('symbols-tree-nav.sortByNameType')
          if typeComp
            typeComp = b.type.localeCompare(a.type)
          if ascending
            nameComp = a.name.localeCompare(b.name)
          else
            nameComp = b.name.localeCompare(a.name)
          return typeComp || nameComp
      @setRoot(@rootNode.item)

    sortByRow: (ascending=true) =>
      @traversal @rootNode, (item) =>
        item.children?.sort (a, b) =>
          if ascending
            return a.position.row - b.position.row
          else
            return b.position.row - a.position.row
      @setRoot(@rootNode.item)

    clearSelect: ->
      $('.list-selectable-item').removeClass('selected')

    select: (item) ->
      @clearSelect()
      item?.view.setSelected()
      if item?.parent?
        $parent = item?.view.closest('.list-nested-item')
        if !$parent.find('div.list-item').first().hasClass('selectedParent')
          $('.selectedParent').removeClass('selectedParent')
          $parent.find('div.list-item').first().addClass('selectedParent')
      else
        $('.selectedParent').removeClass('selectedParent')
