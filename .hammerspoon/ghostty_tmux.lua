-- Menu bar ghost: click to open a Ghostty window that starts in tmux.
--
-- Ghostty itself stays tmux-free. The click launches a separate Ghostty
-- instance with START_TMUX=1 in its environment, and .zshrc sees that flag
-- and replaces the shell with tmux (attaching to the "main" session).

local M = {}

function M.launch()
    hs.task.new("/usr/bin/open", nil, {
        "-na", "Ghostty.app", "--args", "--env=START_TMUX=1",
        -- Without this the new instance restores every saved window and
        -- split, each one attaching to tmux.
        "--window-save-state=never",
    }):start()
end

-- Kept on the returned table so the menu bar item is not garbage collected.
M.menu = hs.menubar.new()

if M.menu then
    M.menu:setTitle("👻")
    M.menu:setTooltip("New Ghostty window in tmux")
    M.menu:setClickCallback(M.launch)
end

return M
