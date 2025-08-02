bg0_hard = "#1d2021"
bg0_soft = '#32302f'
bg0_normal = '#282828'

bg0 = bg0_hard 
bg1 = "#3c3836"
bg2 = "#504945"
bg3 = "#665c54"
bg4 = "#7c6f64"

fg0 = "#fbf1c7"
fg1 = "#ebdbb2"
fg2 = "#d5c4a1"
fg3 = "#bdae93"
fg4 = "#a89984"

bright_red = "#fb4934"
bright_green = "#b8bb26"
bright_yellow = "#fabd2f"
bright_blue = "#83a598"
bright_purple = "#d3869b"
bright_aqua = "#8ec07c"
bright_gray = "#928374"
bright_orange = "#fe8019"

dark_red = "#cc241d"
dark_green = "#98971a"
dark_yellow = "#d79921"
dark_blue = "#458588"
dark_purple = "#b16286"
dark_aqua = "#689d6a"
dark_gray = "#a89984"
dark_orange = "#d65d0e"

### Completion
c.colors.completion.fg = [fg1, bright_aqua, bright_yellow]
c.colors.completion.odd.bg = bg0
c.colors.completion.even.bg = c.colors.completion.odd.bg
c.colors.completion.category.fg = bright_blue
c.colors.completion.category.bg = bg1
c.colors.completion.category.border.top = c.colors.completion.category.bg
c.colors.completion.category.border.bottom = c.colors.completion.category.bg
c.colors.completion.item.selected.fg = fg0
c.colors.completion.item.selected.bg = bg4
c.colors.completion.item.selected.border.top = bg2
c.colors.completion.item.selected.border.bottom = c.colors.completion.item.selected.border.top
c.colors.completion.item.selected.match.fg = bright_orange
c.colors.completion.match.fg = c.colors.completion.item.selected.match.fg
c.colors.completion.scrollbar.fg = c.colors.completion.item.selected.fg
c.colors.completion.scrollbar.bg = c.colors.completion.category.bg

### Context menu
c.colors.contextmenu.disabled.bg = bg3
c.colors.contextmenu.disabled.fg = fg3
c.colors.contextmenu.menu.bg = bg0
c.colors.contextmenu.menu.fg =  fg2
c.colors.contextmenu.selected.bg = bg2
c.colors.contextmenu.selected.fg = c.colors.contextmenu.menu.fg

### Downloads
c.colors.downloads.bar.bg = bg0
c.colors.downloads.start.fg = bg0
c.colors.downloads.start.bg = bright_blue
c.colors.downloads.stop.fg = c.colors.downloads.start.fg
c.colors.downloads.stop.bg = bright_aqua
c.colors.downloads.error.fg = bright_red

### Hints
c.colors.hints.fg = bg0
c.colors.hints.bg = 'rgba(250, 191, 47, 200)'  # bright_yellow
c.colors.hints.match.fg = bg4

### Keyhint widget
c.colors.keyhint.fg = fg4
c.colors.keyhint.suffix.fg = fg0
c.colors.keyhint.bg = bg0

### Messages
c.colors.messages.error.fg = bg0
c.colors.messages.error.bg = bright_red
c.colors.messages.error.border = c.colors.messages.error.bg
c.colors.messages.warning.fg = bg0
c.colors.messages.warning.bg = bright_purple
c.colors.messages.warning.border = c.colors.messages.warning.bg
c.colors.messages.info.fg = fg2
c.colors.messages.info.bg = bg0
c.colors.messages.info.border = c.colors.messages.info.bg

### Prompts
c.colors.prompts.fg = fg2
c.colors.prompts.border = f'1px solid {bg1}'
c.colors.prompts.bg = bg3
c.colors.prompts.selected.bg = bg2

### Statusbar
c.colors.statusbar.normal.fg = fg2
c.colors.statusbar.normal.bg = bg0
c.colors.statusbar.insert.fg = bg0
c.colors.statusbar.insert.bg = dark_aqua
c.colors.statusbar.passthrough.fg = bg0
c.colors.statusbar.passthrough.bg = dark_blue
c.colors.statusbar.private.fg = bright_purple
c.colors.statusbar.private.bg = bg0
c.colors.statusbar.command.fg = fg3
c.colors.statusbar.command.bg = bg1
c.colors.statusbar.command.private.fg = c.colors.statusbar.private.fg
c.colors.statusbar.command.private.bg = c.colors.statusbar.command.bg
c.colors.statusbar.caret.fg = bg0
c.colors.statusbar.caret.bg = dark_purple
c.colors.statusbar.caret.selection.fg = c.colors.statusbar.caret.fg
c.colors.statusbar.caret.selection.bg = bright_purple
c.colors.statusbar.progress.bg = bright_blue
c.colors.statusbar.url.fg = fg4
c.colors.statusbar.url.error.fg = dark_red
c.colors.statusbar.url.hover.fg = bright_orange
c.colors.statusbar.url.success.http.fg = bright_red
c.colors.statusbar.url.success.https.fg = fg0
c.colors.statusbar.url.warn.fg = bright_purple

### tabs
c.colors.tabs.bar.bg = bg0
c.colors.tabs.indicator.start = bright_blue
c.colors.tabs.indicator.stop = bright_aqua
c.colors.tabs.indicator.error = bright_red
c.colors.tabs.odd.fg = fg2
c.colors.tabs.odd.bg = bg2
c.colors.tabs.even.fg = c.colors.tabs.odd.fg
c.colors.tabs.even.bg = bg3
c.colors.tabs.selected.odd.fg = fg2
c.colors.tabs.selected.odd.bg = bg0
c.colors.tabs.selected.even.fg = c.colors.tabs.selected.odd.fg
c.colors.tabs.selected.even.bg = bg0
c.colors.tabs.pinned.even.bg = bright_green
c.colors.tabs.pinned.even.fg = bg2
c.colors.tabs.pinned.odd.bg = bright_green
c.colors.tabs.pinned.odd.fg = c.colors.tabs.pinned.even.fg
c.colors.tabs.pinned.selected.even.bg = bg0
c.colors.tabs.pinned.selected.even.fg = c.colors.tabs.selected.odd.fg
c.colors.tabs.pinned.selected.odd.bg = c.colors.tabs.pinned.selected.even.bg
c.colors.tabs.pinned.selected.odd.fg = c.colors.tabs.selected.odd.fg

# Background color for webpages if unset (or empty to use the theme's
# color).
c.colors.webpage.bg = bg4
