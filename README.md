# symbols-tree-nav package

Symbols Tree View for Atom.io, just like taglist or tagbar for VIM.

tag-generator.coffee comes from [atom/symbols-view](http://github.com/atom/symbols-view).

**Caution** If you want to try symbols-tree-nav, you must first disable symbols-tree-view, then install symbols-tree-nav. These two packages should not ne enabled in the same time (they use the same key bindings for instance...). When you want to get back to symbols-tree-view, just disable (or uninstall) symbols-tree-nav and then enable symbols-tree-view again.

**Disclaimer** This is a fork from [symbols-tree-view](https://atom.io/packages/symbols-tree-view). I am not the original author. symbols-tree-nav only offers some more options, but be warned I am no coffee script expert, so they may be experimental! At least, I use this package and it works at home. PR are welcome! Also, new contributors are welcome.

Whenever possible, I'll create a PR on symbols-tree-view to propose a new feature that is included in symbols-tree-nav.

[symbols-tree-view-fix](https://atom.io/packages/symbols-tree-view-fix) is another fork, without any extra options, but fixes for deprecations warnings.

## Extra Settings
The ones that are not in symbols-tree-view:

* `AutoSort By Name` If this option is enabled then symbols will be sorted by name by default. Credits go to [https://github.com/lowegreg](https://github.com/lowegreg) in [PR #18](https://github.com/nicolashainaux/symbols-tree-nav/pull/18))

* `Sort by name and type` If this option is enabled then sorting by name will also group results by type. Credits go to [https://github.com/lowegreg](https://github.com/lowegreg) in [PR #18](https://github.com/nicolashainaux/symbols-tree-nav/pull/18))

* `Sort by name exceptions` A list of scopes (e.g. "source.yaml") that will not be automatically sorted by name, even if AutoSort By Name is checked.

* `Sort by name enforced` A list of scopes (e.g. "source.python") that will be automatically sorted by name, even if AutoSort By Name is unchecked.

* `Collapsed By Default` Self-explanatory (default=false)

* `Colors From Syntax Theme` If checked, symbols-tree-nav will try to colorize the entries based on the syntax theme you use. Depending on ctags parser results, this support may be incomplete. Do not hesitate to file an Issue and/or a PR to enhance the support. (default=false)

* `Custom Colors` If checked, symbols-tree-nav will use the colors defined in styles/symbols-tree-nav.less for entries when icons are hidden. See example below. These values should override the syntax theme colors. If you wish to share the same colors both when icons are shown or hidden, then just add these definitions on the same line. (default=false)


    .symbols-tree-nav {
      li.list-item {
        .custom-function, .custom-method {
          color: #61afef;
        }
      }
    }

* `Min Titles Length` This is a workaround to be able to see long names that are cut at right. This value is a natural number. When the mouse hover over any element whose length is greater or equal to this value, it will display the complete name as a title. Set it to 0 or 1 to see a title when hovering over any element, or choose the value that's right for your needs. Set it to -1 (default value) to disable this option. (Ref.: [issue #8](https://github.com/nicolashainaux/symbols-tree-nav/issues/8))

* `Show Icons` Self explanatory. If you wish to change the colors, then add entries for `.icon-function`, `.icon-variable` etc. classes in your styles/symbols-tree-nav.less file. (default=true)

* `Show Icons Exceptions` A list of scopes (ex: "python gfm r") what be will the exceptions to the main rule of Show Icons. If you let the default value, nothing special will happen. If you turn Show Icons on, then icons will be displayed in all files except the ones matching this scopes' list. If Show Icons is off, then icons will be displayed only in the files matching this scopes' list.

* `AlternativeCtagsBinary` this one is a workaround intended for Linux users since the Linux Universal Ctags binary provided by symbols-tree-view seems to be a little bit buggy (python files are not correctly parsed, for instance). So you can check that another parser is installed on your system (like Exuberant Ctags) and provide its absolute path here. Leave default to keep using the provided binary. (default='default')

* `Ctags Options` include ctags options (not sure this works well, this is a merge from [PR #14](https://github.com/nicolashainaux/symbols-tree-nav/pull/14); at least it should be harmless and might be fixed if necessary).

## Extra Features (without settings)
Here I'll try to keep an up-to-date list of the features that are proposed in symbols-tree-nav but not (yet?) in symbols-tree-view. Apart from the features already described in the Extra Settings section above.

* Highlight symbol parent when current element is collapsed and other enhancements (credits go to [https://github.com/lowegreg](https://github.com/lowegreg) in [PR #18](https://github.com/nicolashainaux/symbols-tree-nav/pull/18)).

* Enhanced support for markdown files (from [symbols-tree-view PR #138](https://github.com/xndcn/symbols-tree-view/pull/138)) and for YAML files.

* Support for several languages: R, [Elixir](https://github.com/xndcn/symbols-tree-view/pull/167), [taskpaper](https://github.com/xndcn/symbols-tree-view/issues/146), Fountain, Julia, LaTeX, [TypeScript](https://github.com/xndcn/symbols-tree-view/issues/101)

* Bugfix: #148 (from [symbols-tree-view PR #160](https://github.com/xndcn/symbols-tree-view/pull/160))

* Bugfix: #79 (from [symbols-tree-view PR #172](https://github.com/xndcn/symbols-tree-view/pull/172))


## TO DO (yet unchanged)

* Add specs for test

* Improve icons

[new_settings_url]: https://github.com/nicolashainaux/symbols-tree-nav/blob/master/new_settings.png?raw=true
