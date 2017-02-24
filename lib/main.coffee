SymbolsTreeView = require './symbols-tree-view'

module.exports =
  config:
    autoToggle:
      type: 'boolean'
      default: false
      description: 'If this option is enabled then symbols-tree-view will auto open when you open files.'
    scrollAnimation:
      type: 'boolean'
      default: true
      description: 'If this option is enabled then when you click the item in symbols-tree it will scroll to the destination gradually.'
    collapsedByDefault:
      type: 'boolean'
      default: false
      description: 'If this option is enabled then all collapsable elements will be collapsed anytime the tree view is displayed anew.'
    autoHide:
      type: 'boolean'
      default: false
      description: 'If this option is enabled then symbols-tree-view is always hidden unless mouse hover over it.'
    zAutoHideTypes:
      title: 'AutoHideTypes'
      type: 'string'
      description: 'Here you can specify a list of types that will be hidden by default (ex: "variable class")'
      default: ''
    sortByNameScopes:
      type: 'string'
      description: 'Here you can specify a list of scopes that will be sorted by name (ex: "text.html.php")'
      default: ''
    defaultWidth:
      type: 'number'
      description: 'Width of the panel (needs Atom restart)'
      default: 200
    showIcons:
      type: 'boolean'
      default: true
      description: 'If this option is enabled, then icons will be displayed before each element.'
    alternateCtagsBinary:
      type: 'string'
      description: 'Here you can specify a path to a binary to use for ctags creation instead of the one shipped with SymbolsTreeView. For instance, Linux users may want to install exuberant ctags and use it (/usr/bin/ctags). Caution, if the path you specify is wrong, SymbolsTreeView will not work.'
      default: 'default'


  symbolsTreeView: null

  activate: (state) ->
    @symbolsTreeView = new SymbolsTreeView(state.symbolsTreeViewState)
    atom.commands.add 'atom-workspace', 'symbols-tree-view:toggle': => @symbolsTreeView.toggle()
    atom.commands.add 'atom-workspace', 'symbols-tree-view:show': => @symbolsTreeView.showView()
    atom.commands.add 'atom-workspace', 'symbols-tree-view:hide': => @symbolsTreeView.hideView()

    atom.config.observe 'tree-view.showOnRightSide', (value) =>
      if @symbolsTreeView.hasParent()
        @symbolsTreeView.remove()
        @symbolsTreeView.populate()
        @symbolsTreeView.attach()

    atom.config.observe "symbols-tree-view.autoToggle", (enabled) =>
      if enabled
        @symbolsTreeView.toggle() unless @symbolsTreeView.hasParent()
      else
        @symbolsTreeView.toggle() if @symbolsTreeView.hasParent()

  deactivate: ->
    @symbolsTreeView.destroy()

  serialize: ->
    symbolsTreeViewState: @symbolsTreeView.serialize()

  getProvider: ->
    view = @symbolsTreeView

    providerName: 'symbols-tree-view'
    getSuggestionForWord: (textEditor, text, range) =>
      range: range
      callback: ()=>
        view.focusClickedTag.bind(view)(textEditor, text)
