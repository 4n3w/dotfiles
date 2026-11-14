-- Window management
hs.loadSpoon("ShiftIt")
spoon.ShiftIt:bindHotkeys({})
spoon.ShiftIt:setWindowCyclingSizes({ 50, 33, 67 }, { 50 })

-- Caffeine replacement (menu bar icon, display kept awake by default)
amphetamine = require "amphetamine"

-- Menu bar ghost that opens Ghostty in tmux
ghosttyTmux = require "ghostty_tmux"
