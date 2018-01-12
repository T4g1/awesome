
--[[

        Licensed under GNU General Public License v2
        * (c) 2017, Greg Flynn

--]]
local awful = require("awful")
local naughty = require("naughty")
local io, next, os, string, table = io, next, os, string, table

-- Google Play Music Desktop Player widget
-- requires: curl and dkjson or lain

local gpmdp = {
    notify        = "on",
    followtag     = true,
    file_location = os.getenv("HOME") .. "/.config/Google Play Music Desktop Player/json_store/playback.json",
    notification_preset = {
        fg = "#FFFFFF",
        font = "Roboto 10",
        title     = "Now playing",
        icon_size = 48,
        timeout   = 3
    },
    notification  = nil,
    current_track = nil,
    album_cover   = "/tmp/gpmcover",
    settings = function() end
}

function gpmdp.update(widget, stdout)
    widget.font = "Roboto 10"

    -- GPMDP not running?
    local filelines = gpmdp.get_lines(gpmdp.file_location)
    if not filelines then
        gpmdp.widget:set_text("No tracks")
        return
    end

    gpm_now = {
        running = true,
        artist = nil,
        album = nil,
        title = nil,
        cover_url = nil,
        playing = false
    }

    if not next(filelines) then
        gpm_now.running = false
        gpm_now.playing = false
    else
        json = require("dkjson")
        dict = json.decode(table.concat(filelines))
        gpm_now.artist    = dict.song.artist
        gpm_now.album     = dict.song.album
        gpm_now.title     = dict.song.title
        gpm_now.cover_url = dict.song.albumArt
        gpm_now.liked     = dict.rating.liked
        gpm_now.disliked  = dict.rating.disliked
        gpm_now.playing   = dict.playing
    end
    gpmdp.latest = gpm_now

    -- customize here
    if gpm_now.playing then
        gpmdp.notification_preset.text = string.format("%s (%s) - %s", gpm_now.artist, gpm_now.album, gpm_now.title)

        if gpmdp.notify == "on" and gpm_now.title ~= gpmdp.current_track then
            gpmdp.notification_on()
        end
    elseif not gpm_now.running then
        gpmdp.widget:set_text("not running")
        gpmdp.current_track = nil
    end

    gpmdp.settings()
end

function gpmdp.notification_on()
    local gpm_now = gpmdp.latest
    gpmdp.current_track = gpm_now.title

    if gpm_now.cover_url == nil then
        return
    end

    if gpmdp.followtag then gpmdp.notification_preset.screen = awful.screen.focused() end
    awful.spawn.easy_async({"curl", gpm_now.cover_url, "-o", gpmdp.album_cover}, function(stdout)
        local old_id = nil
        if gpmdp.notification then old_id = gpmdp.notification.id end

        gpmdp.notification = naughty.notify({
            preset = gpmdp.notification_preset,
            icon = gpmdp.album_cover,
            replaces_id = old_id
        })
    end)
end

function gpmdp.notification_off()
    if not gpmdp.notification then return end
    naughty.destroy(gpmdp.notification)
    gpmdp.notification = nil
end

function gpmdp.get_lines(file)
    local f = io.open(file)
    if not f then
        return
    else
        f:close()
    end

    local lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

gpmdp.widget = awful.widget.watch({"pidof", "Google Play Music Desktop Player"}, 1, gpmdp.update)

-- add mouse hover
gpmdp.widget:connect_signal("mouse::enter", gpmdp.notification_on)
gpmdp.widget:connect_signal("mouse::leave", gpmdp.notification_off)

return gpmdp
