SymbolsTreeNav = require './symbols-tree-nav'

module.exports =
  config:
    autoToggle:
      type: 'boolean'
      default: false
      description: 'If this option is enabled then symbols-tree-nav will auto open when you open files.'
    scrollAnimation:
      type: 'boolean'
      default: true
      description: 'If this option is enabled then when you click the item in symbols-tree it will scroll to the destination gradually.'
    collapsedByDefault:
      type: 'boolean'
      default: false
      description: 'If this option is enabled then all collapsable elements are displayed collapsed by default.'
    minTitlesLength:
      type: 'number'
      default: -1
      description: 'Any element having a length greater or equal to this value will display a title when mouse hover over it. Default -1 value means that titles will never be displayed.'
    autoHide:
      type: 'boolean'
      default: false
      description: 'If this option is enabled then symbols-tree-nav is always hidden unless mouse hover over it.'
    zAutoHideTypes:
      title: 'AutoHideTypes'
      type: 'string'
      description: 'Here you can specify a list of types that will be hidden by default (ex: "variable class")'
      default: ''
    autoSortByName:
      title: 'Automatically sort by name'
      type: 'boolean'
      default: false
      description: 'If this option is enabled then symbols will be sorted by name by default'
    sortByNameScopes:
      type: 'string'
      description: 'Here you can specify a list of scopes that will be sorted by name (ex: "text.html.php")'
      default: ''
    defaultWidth:
      type: 'number'
      description: 'Width of the panel (needs Atom restart)'
      default: 200
    customColors:
      type: 'boolean'
      description: 'Colorize the entries with user-defined values'
      default: false
    colorsFromSyntaxTheme:
      type: 'boolean'
      description: 'Colorize the entries, matching syntax theme. (Yet experimental; only partial support)'
      default: false
    showIcons:
      type: 'boolean'
      default: true
      description: 'If this option is enabled, then icons will be displayed before each element.'
    showIconsExceptions:
      type: 'string'
      description: 'Here you can specify a list of scopes (ex: gfm python r). If Show Icons is on, then icons will not be displayed for the specified scopes; if Show Icons is off, then icons will be displayed only for the specified scopes. Default value will not affect any scope.'
      default: 'default'
    zzAlternativeCtagsBinary:
      title: 'AlternativeCtagsBinary'
      type: 'string'
      description: 'Here you can specify a path to a binary to use for ctags creation instead of the one shipped with symbols-tree-nav. For instance, Linux users may want to use the binary available for their distribution (exuberant or universal, usually it is /usr/bin/ctags). Caution, if the path you specify is wrong, symbols-tree-nav will not work.'
      default: 'default'


  symbolsTreeNav: null

  activate: (state) ->
    @symbolsTreeNav = new SymbolsTreeNav(state.symbolsTreeNavState)
    atom.commands.add 'atom-workspace', 'symbols-tree-nav:toggle': => @symbolsTreeNav.toggle()
    atom.commands.add 'atom-workspace', 'symbols-tree-nav:show': => @symbolsTreeNav.showView()
    atom.commands.add 'atom-workspace', 'symbols-tree-nav:hide': => @symbolsTreeNav.hideView()

    atom.config.observe 'tree-view.showOnRightSide', (value) =>
      if @symbolsTreeNav.hasParent()
        @symbolsTreeNav.remove()
        @symbolsTreeNav.populate()
        @symbolsTreeNav.attach()

    atom.config.observe "symbols-tree-nav.autoToggle", (enabled) =>
      if enabled
        @symbolsTreeNav.toggle() unless @symbolsTreeNav.hasParent()
      else
        @symbolsTreeNav.toggle() if @symbolsTreeNav.hasParent()

  deactivate: ->
    @symbolsTreeNav.destroy()

  serialize: ->
    symbolsTreeNavState: @symbolsTreeNav.serialize()

  getProvider: ->
    view = @symbolsTreeNav

    providerName: 'symbols-tree-nav'
    getSuggestionForWord: (textEditor, text, range) =>
      range: range
      callback: ()=>
        view.focusClickedTag.bind(view)(textEditor, text)
