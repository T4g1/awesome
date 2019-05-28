
--[[

     Holo Awesome WM theme 3.0
     github.com/copycat-killer

--]]

local gears  = require("gears")
local lain   = require("lain")
local awful  = require("awful")
local wibox  = require("wibox")
local beautiful  = require("beautiful")
local gpmdp  = require("gpmdp")
local string = string
local clock = os.clock
local os     = { getenv = os.getenv }

local theme                                     = {}
theme.default_dir                               = require("awful.util").get_themes_dir() .. "default"
theme.icon_dir                                  = os.getenv("HOME") .. "/.config/awesome/themes/holo/icons"
--theme.wallpaper                                 = os.getenv("HOME") .. "/images/wallpapers/wallhaven-3326.jpg"
theme.font                                      = "Roboto Bold 10"
theme.taglist_font                              = "Roboto Condensed Regular 8"
theme.fg_normal                                 = "#FFFFFF"
theme.fg_focus                                  = "#0099CC"
theme.bg_focus                                  = "#303030"
theme.bg_normal                                 = "#242424"
theme.fg_urgent                                 = "#CC9393"
theme.bg_urgent                                 = "#006B8E"
theme.border_width                              = 3
theme.border_normal                             = "#252525"
theme.border_focus                              = "#0099CC"
theme.taglist_fg_focus                          = "#FFFFFF"
theme.tasklist_bg_normal                        = "#222222"
theme.tasklist_fg_focus                         = "#4CB7DB"
theme.menu_height                               = 20
theme.menu_width                                = 160
theme.menu_icon_size                            = 32
theme.awesome_icon                              = theme.icon_dir .. "/awesome_icon_white.png"
theme.awesome_icon_launcher                     = theme.icon_dir .. "/awesome_icon.png"
theme.taglist_squares_sel                       = theme.icon_dir .. "/square_sel.png"
theme.taglist_squares_unsel                     = theme.icon_dir .. "/square_unsel.png"
theme.spr_small                                 = theme.icon_dir .. "/spr_small.png"
theme.spr_very_small                            = theme.icon_dir .. "/spr_very_small.png"
theme.spr_right                                 = theme.icon_dir .. "/spr_right.png"
theme.spr_bottom_right                          = theme.icon_dir .. "/spr_bottom_right.png"
theme.spr_left                                  = theme.icon_dir .. "/spr_left.png"
theme.bar                                       = theme.icon_dir .. "/bar.png"
theme.bottom_bar                                = theme.icon_dir .. "/bottom_bar.png"
theme.mpdl                                      = theme.icon_dir .. "/mpd.png"
theme.mpd_on                                    = theme.icon_dir .. "/mpd_on.png"
theme.prev                                      = theme.icon_dir .. "/prev.png"
theme.nex                                       = theme.icon_dir .. "/next.png"
theme.stop                                      = theme.icon_dir .. "/stop.png"
theme.pause                                     = theme.icon_dir .. "/pause.png"
theme.play                                      = theme.icon_dir .. "/play.png"
theme.like                                      = theme.icon_dir .. "/like.png"
theme.liked                                     = theme.icon_dir .. "/liked.png"
theme.dislike                                   = theme.icon_dir .. "/dislike.png"
theme.disliked                                  = theme.icon_dir .. "/disliked.png"
theme.clock                                     = theme.icon_dir .. "/clock.png"
theme.calendar                                  = theme.icon_dir .. "/cal.png"
theme.cpu                                       = theme.icon_dir .. "/cpu.png"
theme.net_up                                    = theme.icon_dir .. "/net_up.png"
theme.net_down                                  = theme.icon_dir .. "/net_down.png"
theme.widget_kbd                                = theme.icon_dir .. "/kbd.png"
theme.widget_vol                                = theme.icon_dir .. "/vol.png"
theme.widget_weather                            = theme.icon_dir .. "/dish.png"
theme.widget_fs                                 = theme.icon_dir .. "/fs.png"
theme.widget_batt                               = theme.icon_dir .. "/bat.png"
theme.layout_tile                               = theme.icon_dir .. "/tile.png"
theme.layout_tileleft                           = theme.icon_dir .. "/tileleft.png"
theme.layout_tilebottom                         = theme.icon_dir .. "/tilebottom.png"
theme.layout_tiletop                            = theme.icon_dir .. "/tiletop.png"
theme.layout_fairv                              = theme.icon_dir .. "/fairv.png"
theme.layout_fairh                              = theme.icon_dir .. "/fairh.png"
theme.layout_spiral                             = theme.icon_dir .. "/spiral.png"
theme.layout_dwindle                            = theme.icon_dir .. "/dwindle.png"
theme.layout_max                                = theme.icon_dir .. "/max.png"
theme.layout_fullscreen                         = theme.icon_dir .. "/fullscreen.png"
theme.layout_magnifier                          = theme.icon_dir .. "/magnifier.png"
theme.layout_floating                           = theme.icon_dir .. "/floating.png"
theme.layout_centerfair                         = theme.icon_dir .. "/centerfair.png"
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true
theme.useless_gap                               = 4
theme.titlebar_close_button_normal              = theme.default_dir.."/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = theme.default_dir.."/titlebar/close_focus.png"
theme.titlebar_minimize_button_normal           = theme.default_dir.."/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus            = theme.default_dir.."/titlebar/minimize_focus.png"
theme.titlebar_ontop_button_normal_inactive     = theme.default_dir.."/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = theme.default_dir.."/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = theme.default_dir.."/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = theme.default_dir.."/titlebar/ontop_focus_active.png"
theme.titlebar_sticky_button_normal_inactive    = theme.default_dir.."/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = theme.default_dir.."/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = theme.default_dir.."/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = theme.default_dir.."/titlebar/sticky_focus_active.png"
theme.titlebar_floating_button_normal_inactive  = theme.default_dir.."/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = theme.default_dir.."/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = theme.default_dir.."/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = theme.default_dir.."/titlebar/floating_focus_active.png"
theme.titlebar_maximized_button_normal_inactive = theme.default_dir.."/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = theme.default_dir.."/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = theme.default_dir.."/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = theme.default_dir.."/titlebar/maximized_focus_active.png"

theme.musicplr = string.format("%s -e ncmpcpp", awful.util.terminal)

local markup = lain.util.markup
local blue   = "#80CCE6"
local space3 = markup.font("Roboto 3", " ")

-- Clock
local mytextclock = wibox.widget.textclock(markup("#FFFFFF", space3 .. "%H:%M " .. markup.font("Roboto 4", " ")))
mytextclock.font = theme.font
local clock_icon = wibox.widget.imagebox(theme.clock)
local clockbg = wibox.container.background(mytextclock, theme.bg_focus, gears.shape.rectangle)
local clockwidget = wibox.container.margin(clockbg, 0, 3, 5, 5)

-- Calendar
local mytextcalendar = wibox.widget.textclock(markup.fontfg(theme.font, "#FFFFFF", space3 .. "%d %b " .. markup.font("Roboto 5", " ")))
local calendar_icon = wibox.widget.imagebox(theme.calendar)
local calbg = wibox.container.background(mytextcalendar, theme.bg_focus, gears.shape.rectangle)
local calendarwidget = wibox.container.margin(calbg, 0, 0, 5, 5)
lain.widget.calendar({
    followtag = true,
    attach_to = { mytextclock, mytextcalendar },
    notification_preset = {
        fg = "#FFFFFF",
        bg = theme.bg_normal,
        position = "bottom_right",
        font = "Monospace 10"
    }
})

-- Weather
local weather_icon = wibox.widget.imagebox(theme.widget_weather)
theme.weather = lain.widget.weather({
    city_id = 2800866,
    notification_preset = {
        font = "Monospace 9",
        position = "bottom_right" },
    weather_na_markup = markup.fontfg(theme.font, "#ffffff", "N/A "),
    settings = function()
        descr = weather_now["weather"][1]["description"]:lower()
        units = math.floor(weather_now["main"]["temp"])
        widget:set_markup(markup.fontfg(theme.font, "#ffffff", " " .. descr .. " @ " .. units .. "°C "))
    end
})
local weatherwidget = wibox.container.background(theme.weather.widget, theme.bg_focus, gears.shape.rectangle)
weatherwidget = wibox.container.margin(weatherwidget, 0, 0, 5, 5)

--[[ Mail IMAP check
-- commented because it needs to be set before use
local mail = lain.widget.imap({
    timeout  = 180,
    server   = "server",
    mail     = "mail",
    password = "keyring get mail",
    settings = function()
        mail_notification_preset.fg = "#FFFFFF"
        mail  = ""
        count = ""

        if mailcount > 0 then
            mail = "Mail "
            count = mailcount .. " "
        end

        widget:set_markup(markup.font(theme.font, markup(blue, mail) .. markup("#FFFFFF", count)))
    end
})
--]]

-- Music
local mpd_icon = awful.widget.launcher({ image = theme.mpdl, command = theme.musicplr })
local prev_icon = wibox.widget.imagebox(theme.prev)
local next_icon = wibox.widget.imagebox(theme.nex)
local stop_icon = wibox.widget.imagebox(theme.stop)
local pause_icon = wibox.widget.imagebox(theme.pause)
local play_pause_icon = wibox.widget.imagebox(theme.play)
local like_icon = wibox.widget.imagebox(theme.like)
local dislike_icon = wibox.widget.imagebox(theme.dislike)

gpmdp.settings = function ()
    local gpm_now = gpmdp.latest

    if gpm_now.artist ~= nil then
        if gpm_now.liked then
            like_icon:set_image(theme.liked)
            dislike_icon:set_image(theme.dislike)
        elseif gpm_now.disliked then
            like_icon:set_image(theme.like)
            dislike_icon:set_image(theme.disliked)
        else
            like_icon:set_image(theme.like)
            dislike_icon:set_image(theme.dislike)
        end
    end

    if gpmdp.latest.playing then
        gpmdp.widget:set_text(gpm_now.artist .. " - " .. gpm_now.title)
        play_pause_icon:set_image(theme.pause)
    else
        play_pause_icon:set_image(theme.play)
        if gpm_now.artist ~= nil then
            gpmdp.widget:set_text(gpm_now.artist .. " - " .. gpm_now.title .. " - PAUSED")
        else
            gpmdp.widget:set_text("No tracks")
        end
    end
end
local music_icon = wibox.widget.imagebox(theme.mpdl)
local musicbg = wibox.container.background(gpmdp.widget, theme.bg_focus, gears.shape.rectangle)
local musicwidget = wibox.container.margin(musicbg, 0, 0, 5, 5)

musicwidget:buttons(awful.util.table.join(awful.button({ }, 1,
function ()
    awful.spawn(theme.musicplr)
end)))
prev_icon:buttons(awful.util.table.join(awful.button({}, 1,
function ()
    awful.spawn.with_shell("xdotool key alt+ctrl+Left")
    gpmdp.widget:set_text("Previous...")
end)))
next_icon:buttons(awful.util.table.join(awful.button({}, 1,
function ()
    awful.spawn.with_shell("xdotool key alt+ctrl+Right")
    gpmdp.widget:set_text("Next...")
end)))
stop_icon:buttons(awful.util.table.join(awful.button({}, 1,
function ()
    play_pause_icon:set_image(theme.play)
    awful.spawn.with_shell("xdotool key alt+ctrl+Down")
end)))
play_pause_icon:buttons(awful.util.table.join(awful.button({}, 1,
function ()
    awful.spawn.with_shell("xdotool key alt+ctrl+Up")
end)))
like_icon:buttons(awful.util.table.join(awful.button({ }, 1,
function ()
    awful.spawn.with_shell("xdotool key alt+ctrl+l")
end)))
dislike_icon:buttons(awful.util.table.join(awful.button({ }, 1,
function ()
    awful.spawn.with_shell("xdotool key alt+ctrl+d")
end)))

-- keyboard layout
local kbd_icon = wibox.widget.imagebox(theme.widget_kbd)
local kbd = lain.widget.contrib.kbdlayout({
    layouts = {
        { layout = "be" },
        { layout = "fr" }
    },
    settings = function()
        kbd_text = " " .. kbdlayout_now.layout .. " "
        widget:set_markup(markup.font(theme.font, kbd_text))
    end
})
local kbdwidget = wibox.container.background(kbd.widget, theme.bg_focus, gears.shape.rectangle)
kbdwidget = wibox.container.margin(kbdwidget, 0, 0, 5, 5)

--  fs
local fs_icon = wibox.widget.imagebox(theme.widget_fs)
theme.fs = lain.widget.fs({
    options = "--exclude-type=tmpfs",
    followtag = true,
    notification_preset = {
        bg = theme.bg_normal,
        font = "Consolas 10",
        fg   = "#FFFFFF",
    },
    settings  = function()
        local home_used = tonumber(fs_info["/home used_p"]) or 0
        widget:set_markup(markup.font(theme.font, " " .. fs_now.used .. "% "))
    end
})
local fswidget = wibox.container.background(theme.fs.widget, theme.bg_focus, gears.shape.rectangle)
fswidget = wibox.container.margin(fswidget, 0, 0, 5, 5)

-- Battery
local bat_icon = wibox.widget.imagebox(theme.widget_batt)
local bat = lain.widget.bat({
    batteries = {"BAT", "BAT0"},
    ac = "AC",
    timeout = 1,
    settings = function()
        bat_p      = bat_now.perc .. "% "
        if bat_now.ac_status == 1 then
            bat_p = bat_p .. "Plugged "
        end
        widget:set_markup(markup.font(theme.font, bat_p))
    end
})
local batwidget = wibox.container.background(bat.widget, theme.bg_focus, gears.shape.rectangle)
batwidget = wibox.container.margin(batwidget, 0, 0, 5, 5)

-- ALSA volume bar
local volume_icon = wibox.widget.imagebox(theme.widget_vol)
theme.volume = lain.widget.alsa({
    cmd = "amixer -D pulse",
    --togglechannel = "Headset",
    settings = function()
        vol = volume_now.level .. "% "
        if volume_now.status == "off" then
            vol = vol .. "Muted "
        end
        widget:set_markup(markup.font(theme.font, vol))
    end
})

theme.volume.widget:buttons(awful.util.table.join(
    awful.button({}, 3, function() -- right click
        awful.spawn("pavucontrol")
    end),
    awful.button({}, 1, function() -- left click
        awful.spawn(string.format("%s set %s toggle", theme.volume.cmd, theme.volume.channel))
        theme.volume.update()
        theme.volume.update()
        theme.volume.update()
        theme.volume.update()
        theme.volume.update()
        theme.volume.update()
    end),
    awful.button({}, 4, function() -- scroll up
        awful.spawn(string.format("%s set %s 1%%+", theme.volume.cmd, theme.volume.channel))
        theme.volume.update()
    end),
    awful.button({}, 5, function() -- scroll down
        awful.spawn(string.format("%s set %s 1%%-", theme.volume.cmd, theme.volume.channel))
        theme.volume.update()
    end)
))
local volumewidget = wibox.container.background(theme.volume.widget, theme.bg_focus, gears.shape.rectangle)
volumewidget = wibox.container.margin(volumewidget, 0, 0, 5, 5)

-- CPU
local cpu_icon = wibox.widget.imagebox(theme.cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(space3 .. markup.font(theme.font, "CPU " .. cpu_now.usage
                          .. "% ") .. markup.font("Roboto 5", " "))
    end
})
local cpubg = wibox.container.background(cpu.widget, theme.bg_focus, gears.shape.rectangle)
local cpuwidget = wibox.container.margin(cpubg, 0, 0, 5, 5)

-- Net
local netdown_icon = wibox.widget.imagebox(theme.net_down)
local netup_icon = wibox.widget.imagebox(theme.net_up)
local net = lain.widget.net({
    settings = function()
        widget:set_markup(markup.font("Roboto 1", " ") .. markup.font(theme.font, net_now.received .. " - "
                          .. net_now.sent) .. markup.font("Roboto 2", " "))
    end
})
local netbg = wibox.container.background(net.widget, theme.bg_focus, gears.shape.rectangle)
local networkwidget = wibox.container.margin(netbg, 0, 0, 5, 5)

-- Systray
local systray = wibox.widget.systray()
local systraybg = wibox.container.background(systray, theme.bg_focus, gears.shape.rectangle)
local systraywidget = wibox.container.margin(systraybg, 0, 0, 5, 5)

-- Launcher
local mylauncher = awful.widget.button({ image = theme.awesome_icon_launcher })
mylauncher:connect_signal("button::press", function() awful.util.mymainmenu:toggle() end)

-- Separators
local first = wibox.widget.textbox('<span font="Roboto 7"> </span>')
local spr_small = wibox.widget.imagebox(theme.spr_small)
local spr_very_small = wibox.widget.imagebox(theme.spr_very_small)
local spr_right = wibox.widget.imagebox(theme.spr_right)
local spr_bottom_right = wibox.widget.imagebox(theme.spr_bottom_right)
local spr_left = wibox.widget.imagebox(theme.spr_left)
local bar = wibox.widget.imagebox(theme.bar)
local bottom_bar = wibox.widget.imagebox(theme.bottom_bar)

local barcolor  = gears.color({
    type  = "linear",
    from  = { 32, 0 },
    to    = { 32, 32 },
    stops = { {0, theme.bg_focus}, {0.25, "#505050"}, {1, theme.bg_focus} }
})

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- If wallpaper is a function, call it with the screen
    --local wallpaper = theme.wallpaper
    --if type(wallpaper) == "function" then
    --    wallpaper = wallpaper(s)
    --end
    --gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons, { bg_focus = barcolor })

    mytaglistcont = wibox.container.background(s.mytaglist, theme.bg_focus, gears.shape.rectangle)
    s.mytag = wibox.container.margin(mytaglistcont, 0, 0, 5, 5)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons, { bg_focus = theme.bg_focus, shape = gears.shape.rectangle, shape_border_width = 5, shape_border_color = theme.tasklist_bg_normal, align = "center" })

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 32 })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            first,
            s.mytag,
            spr_right,
            s.mylayoutbox,

            spr_left,
            mpd_icon,
            prev_icon,
            next_icon,
            stop_icon,
            play_pause_icon,
            like_icon,
            dislike_icon,
            bar,
            musicwidget,
            spr_small,

            s.mypromptbox,
        },
        { -- Middle widgets
            layout = wibox.layout.flex.horizontal,
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,

            systraywidget,

            --mail.widget,

            spr_right,
            kbd_icon,
            kbdwidget,
            spr_left,

            netdown_icon,
            networkwidget,
            netup_icon,
            spr_left,

            cpu_icon,
            cpuwidget,
            spr_left,
            fs_icon,
            fswidget,
            spr_left,
            --bat_icon,
            --batwidget,
            --spr_left,
            volume_icon,
            volumewidget,
            spr_left,
        },
    }

    -- Create the bottom wibox
    s.mybottomwibox = awful.wibar({ position = "bottom", screen = s, border_width = 0, height = 32 })
    s.borderwibox = awful.wibar({ position = "bottom", screen = s, height = 1, bg = theme.fg_focus, x = 0, y = 33})

    -- Add widgets to the bottom wibox
    s.mybottomwibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            weather_icon,
            weatherwidget,
            spr_left,
            calendar_icon,
            calendarwidget,
            spr_left,
            clock_icon,
            clockwidget,
        },
    }
end

return theme
