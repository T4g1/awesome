--[[
     Awesome WM configuration T4g1
     github.com/copycat-killer
--]]

-- {{{ Required libraries
local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
local freedesktop   = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local remote        = require("awful.remote")
local lfs           = require("lfs")
local remote        = require("awful.remote")
local xrandr        = require("xrandr")

-- }}}

beautiful.notification_icon_size = 48

-- {{{ Error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Autostart windowless processes
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        findme = cmd
        firstspace = cmd:find(" ")
        if firstspace then
            findme = cmd:sub(0, firstspace-1)
        end
        awful.spawn.with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd))
    end
end

run_once({ "unclutter -root -reset" }) -- entries must be comma-separated
-- }}}

-- {{{ Variable definitions
local chosen_theme = "holo"
local modkey       = "Mod4"
local altkey       = "Mod1"
local terminal     = "xterm"
local editor       = os.getenv("EDITOR") or "nano"
local browser      = "chromium"
local guieditor    = "subl"
local screenshot   = "export QT_QPA_PLATFORMTHEME=; deepin-screenshot"

local terminal_screen = 1
local browser_screen = 1
local music_screen = 2
local editor_screen = 3

-- {{{ Set screen wibox visibility
local function set_wibox_visibility(s, visibility)
    s.mywibox.visible = visibility
    if s.mybottomwibox then
        s.mybottomwibox.visible = visibility
    end
end
-- }}}

-- {{{ Hide screen wibox
local function hide_wibox(s)
    set_wibox_visibility(s, false)
end
-- }}}

-- {{{ Show screen wibox
local function show_wibox(s)
    set_wibox_visibility(s, true)
end
-- }}}

-- {{{ Toggle screen wibox
local function toggle_wibox(s)
    set_wibox_visibility(s, not s.mywibox.visible)
end
-- }}}

awful.util.terminal = terminal
awful.util.tagnames = {}

awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.spiral,
    awful.layout.suit.max,
    lain.layout.termfair.center,
}
awful.util.taglist_buttons = awful.util.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end)
)
awful.util.tasklist_buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end),
    awful.button({ }, 3, function()
        local instance = nil

        return function ()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({ theme = { width = 250 } })
            end
        end
    end),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
    end)
)

lain.layout.termfair.nmaster           = 3
lain.layout.termfair.ncol              = 1
lain.layout.termfair.center.nmaster    = 3
lain.layout.termfair.center.ncol       = 1
lain.layout.cascade.tile.offset_x      = 2
lain.layout.cascade.tile.offset_y      = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster       = 5
lain.layout.cascade.tile.ncol          = 2

local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme)
beautiful.init(theme_path)
-- }}}

-- {{{ Menu
local myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end }
}
awful.util.mymainmenu = freedesktop.menu.build({
    icon_size = beautiful.menu_height or 16,
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        -- other triads can be put here
    },
    after = {
        { "Open terminal", terminal },
        -- other triads can be put here
    }
})
-- }}}

-- {{{ Wallpappers
local wp_path = "/home/t4g1/images/wallpapers/"
local wp_files = {}

for file in lfs.dir(wp_path) do
    table.insert(wp_files, file)
end

local taken = {}

local function add_wallpaper(s)
    wp_index = math.random(1, #wp_files)
    while taken[wp_index] do
        wp_index = math.random(1, #wp_files)
    end

    taken[wp_index] = true
    gears.wallpaper.maximized(wp_path .. wp_files[wp_index], s, true)
end

local function set_wallpaper()
    taken = {}

    for s = 1, screen.count() do
        add_wallpaper(s)
    end
end
-- }}}

wp_timer = gears.timer {
    timeout   = 3600,
    autostart = true,
    callback  = set_wallpaper
}
set_wallpaper()

-- {{{ Screen
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
    beautiful.at_screen_connect(s)

    if s.index == music_screen then
        awful.tag.add("MUSIC", {
            layout             = awful.layout.suit.floating,
            screen             = s.index,
            selected           = true,
        })

        hide_wibox(s)
    end

    if s.index == terminal_screen then
        awful.tag.add("TERMINAL", {
            layout             = lain.layout.termfair.center,
            screen             = s.index,
            selected           = true,
        })

        awful.tag.add("BROWSER", {
            layout             = awful.layout.suit.floating,
            screen             = s.index,
            selected           = false,
        })
    end

    if s.index == editor_screen then
        awful.tag.add("EDITOR", {
            layout             = awful.layout.suit.floating,
            screen             = s.index,
            selected           = true,
        })

        hide_wibox(s)
    end

    awful.tag.add("OTHER", { layout = awful.layout.suit.floating, screen = s.index })
    for i=1,5 do
        awful.tag.add(i, { layout = lain.layout.termfair.floating, screen = s.index })
    end

    add_wallpaper(s.index)
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    -- Swap to all possible arrangements of monitors
    awful.key({ modkey }, "p", function() xrandr.xrandr() end,
              {description="switch external displays", group="screen"}),

    -- Lock screen
    awful.key({ modkey }, "l", function() os.execute("xscreensaver-command -lock") end,
              {description="lock screen", group="awesome"}),

    -- Take a screenshot
    awful.key({ altkey }, "p", function() os.execute(screenshot) end,
              {description="take a screenshot", group="awesome"}),

    -- Hotkeys
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    -- Tag browsing
    awful.key({ modkey, "Control" }, "Tab",  function () lain.util.tag_view_nonempty(1) end,
              {description = "view next nonempty", group = "tag"}),
    awful.key({ modkey, "Control" }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey, "Control" }, "Left",  awful.tag.viewprev,
              {description = "view previous", group = "tag"}),

    -- Default client focus
    awful.key({ altkey }, "Tab", function () awful.client.focus.byidx( 1) end,
              {description = "focus next by index", group = "client"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),

    awful.key({ modkey            }, "Tab", function () awful.screen.focus_relative(1) end,
              {description = "focus the next screen", group = "screen"}),

    -- Show/Hide Wibox
    awful.key({ modkey }, "b",
        function ()
            toggle_wibox(mouse.screen)
        end,
        {description = "toggle wibox", group = "awesome"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    -- Copy primary to clipboard (terminals to gtk)
    awful.key({ modkey }, "c", function () awful.spawn("xsel | xsel -i -b") end),
    -- Copy clipboard to primary (gtk to terminals)
    awful.key({ modkey }, "v", function () awful.spawn("xsel -b | xsel") end),

    -- User programs
    awful.key({ modkey }, "q", function () awful.spawn(browser) end),
    awful.key({ modkey }, "a", function () awful.spawn(guieditor) end),

    -- Prompt
    awful.key({ modkey }, "r", function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"})
)

clientkeys = awful.util.table.join(
    awful.key({ modkey, "Control" }, "t",       awful.titlebar.toggle,
      {description = "Toggle title bar", group = "client"}),
    awful.key({ altkey, "Shift"   }, "m",      lain.util.magnify_client                         ),
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ altkey            }, "F4",      function (c) c:kill() end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen() end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"})
    )
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen+awful.placement.centered,
                     size_hints_honor = false
     }
    },

    -- Titlebars
    { rule_any = { type = { "dialog", "normal" } },
      properties = { titlebars_enabled = true } },

    { rule = { class = "Chromium", type = "normal" },
      properties = {
        screen = terminal_screen,
        tag = "BROWSER",
        maximised = true,
        titlebars_enabled = false,
        floating = false,
        border_width = 0
      }
    },

    { rule = { class = "Google Play Music Desktop Player", type = "normal" },
      properties = {
        screen = music_screen,
        tag = "BROWSER",
        maximised = true,
        titlebars_enabled = false,
        floating = false,
        border_width = 0
      }
    },

    { rule = { class = "vlc", type = "utility" },
      properties = {
        titlebars_enabled = false,
        border_width = 0
      }
    },

    { rule = { class = "Sublime_text", type = "normal" },
      properties = {
        screen = editor_screen,
        tag = "EDITOR",
        maximised = true,
        titlebars_enabled = false,
        floating = false,
        border_width = 0
      }
    }
}
-- }}}

-- Toggle titlebar on or off depending on s. Creates titlebar if it doesn't exist
local function setTitlebar(client, s)
    if s then
        if client.titlebar == nil then
            client:emit_signal("request::titlebars", "rules", {})
        end
        awful.titlebar.show(client)
    else
        awful.titlebar.hide(client)
    end
end

--Toggle titlebar on floating status change
--client.connect_signal("property::floating", function(c)
--    setTitlebar(c, c.floating)
--end)

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end
    if c.first_tag ~= nil and c.first_tag.layout == lain.layout.termfair.center and c.class == "XTerm" then
        setTitlebar(c, false)
    end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = awful.util.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, {size = 16}) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- No border for maximized clients
client.connect_signal("property::maximized", function(c)
    if c.maximized then
        c.border_width = 0
    --else
    --    c.border_width = beautiful.border_width
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

beautiful.systray_icon_spacing = 10

awful.spawn.with_shell("~/.config/awesome/autorun.sh")
