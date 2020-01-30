-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
--require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init(gears.filesystem.get_themes_dir() .. "gtk/theme.lua")

-- Wallpaper
beautiful.wallpaper = "/usr/share/backgrounds/Spices_in_Athens_by_Makis_Chourdakis.jpg"

-- This is used later as the default terminal and editor to run.
terminal = "sakura"
editor = os.getenv("EDITOR") or "vi"
editor_cmd = terminal .. " -e " .. editor

-- Default key_mod.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
key_mod = "Mod4"
key_alt = "Mod1"
key_shift = "Shift"
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
menu_awesome = {
	{ "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
	{ "Manual", terminal .. " -e man awesome" },
	{ "Edit config", editor_cmd .. " " .. awesome.conffile },
	{ "Restart", awesome.restart },
	{ "Quit", function() awesome.quit() end },
}

menu_exit = {
	{ "Reboot", "reboot" },
	{ "Shutdown", "shutdown now" },
	{ "Switch user", "dm-tool switch-to-greeter" },
	{ "Suspend", "systemctl suspend" },
	{ "Log out", function() awesome.quit() end },
}

menu_main = awful.menu({ items = {
	{ "Awesome", menu_awesome, beautiful.awesome_icon },
	{ "Terminal", terminal },
	{ "File", "pcmanfm-qt" },
	{ "Web", "firefox" },
	{ "Editor", "mousepad" },
	{ "Rofi Drun", "rofi -show drun -show-icons" },
	{ "Exit", menu_exit },
}})

launcher_main = awful.widget.launcher({
	image = beautiful.awesome_icon,
	menu = menu_main,
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Tag
-- Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({
		awful.layout.suit.tile,
		awful.layout.suit.tile.bottom,
		awful.layout.suit.floating,
		awful.layout.suit.max,
		-- awful.layout.suit.tile.left,
		--awful.layout.suit.tile.top,
		--awful.layout.suit.fair,
		--awful.layout.suit.fair.horizontal,
		--awful.layout.suit.spiral,
		-- awful.layout.suit.spiral.dwindle,
		-- awful.layout.suit.max.fullscreen,
		-- awful.layout.suit.magnifier,
		-- awful.layout.suit.corner.nw,
	})

	-- awful.layout.append_default_layouts({
	-- 	awful.layout.suit.floating,
	-- 	awful.layout.suit.spiral.dwindle,
	-- 	awful.layout.suit.max,
	-- 	awful.layout.suit.tile,
	-- 	awful.layout.suit.tile.left,
	-- 	awful.layout.suit.tile.bottom,
	-- 	awful.layout.suit.tile.top,
	-- 	awful.layout.suit.fair,
	-- 	awful.layout.suit.fair.horizontal,
	-- 	awful.layout.suit.spiral,
	-- 	-- awful.layout.suit.max.fullscreen,
	-- 	awful.layout.suit.magnifier,
	-- 	awful.layout.suit.corner.nw,
	-- })

end)
-- }}}

-- {{{ Wibar

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
mytextclock = wibox.widget.textclock()

screen.connect_signal("request::wallpaper", function(s)
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

screen.connect_signal("request::desktop_decoration", function(s)
	-- Each screen has its own tag table.
	-- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
	awful.tag({ "Term", "Edit", "File", "Web", "Misc", "Free"}, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox {
        screen  = s,
        buttons = {
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc( 1) end),
            awful.button({ }, 5, function () awful.layout.inc(-1) end),
        }
    }

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = {
            awful.button({ }, 1, function(t) t:view_only() end),
            awful.button({ key_mod }, 1, function(t)
                                            if client.focus then
                                                client.focus:move_to_tag(t)
                                            end
                                        end),
            awful.button({ }, 3, awful.tag.viewtoggle),
            awful.button({ key_mod }, 3, function(t)
                                            if client.focus then
                                                client.focus:toggle_tag(t)
                                            end
                                        end),
            awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
            awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end),
        }
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = {
            awful.button({ }, 1, function (c)
                c:activate { context = "tasklist", action = "toggle_minimization" }
            end),
            awful.button({ }, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
            awful.button({ }, 4, function() awful.client.focus.byidx( 1) end),
            awful.button({ }, 5, function() awful.client.focus.byidx(-1) end),
        }
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox.widget = {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            launcher_main,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
awful.mouse.append_global_mousebindings({
    awful.button({ }, 3, function () menu_main:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev),
})
-- }}}

-- {{{ Key bindings

--------------------------------------------------------------------------------
--- Head: Applications
--

awful.keyboard.append_global_keybindings({
	awful.key(
		{ key_alt }, "Return", function () awful.spawn(terminal) end,
		{ description = "Terminal", group = "App"}
	),

	awful.key(
		{ key_alt, key_shift }, "d", function () awful.spawn("rofi -show drun -show-icons") end,
		{ description = "Rofi Show Drun", group = "Rofi"}
	),

	awful.key(
		{ key_alt, key_shift }, "r", function () awful.spawn("rofi -show run") end,
		{ description = "Rofi Show Run", group = "Rofi"}
	),

	awful.key(
		{ key_alt, key_shift }, "w", function () awful.spawn("rofi -show window -show-icons") end,
		{ description = "Rofi Show Window", group = "Rofi"}
	),

	awful.key(
		{ key_alt, key_shift }, "t", function () awful.spawn("tilix --quake") end,
		{ description = "Tilix Quake", group = "App"}
	),

	awful.key(
		{ key_alt, key_shift }, "f", function () awful.spawn("pcmanfm-qt") end,
		{ description = "Pcmanfm-qt", group = "App"}
	),

	awful.key(
		{ key_alt, key_shift }, "g", function () awful.spawn("nautilus") end,
		{ description = "Nautilus", group = "App"}
	),

	awful.key(
		{ key_alt, key_shift }, "e", function () awful.spawn("gedit") end,
		{ description = "Gedit", group = "App"}
	),

	awful.key(
		{ key_alt, key_shift }, "b", function () awful.spawn("firefox") end,
		{ description = "Firefox", group = "App"}
	),

	awful.key(
		{ key_alt, key_shift }, "x", function() awesome.quit() end,
		{ description = "Logout", group = "Exit"}
	),

	awful.key(
		{ key_alt, key_shift }, "c", awesome.restart,
		{ description = "Awesome Restart", group = "Awesome"}
	),
})

--
--- Tail: Applications
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- Head: Misc
--

awful.keyboard.append_global_keybindings({

	awful.key(
		{ key_mod }, "F1", hotkeys_popup.show_help,
		{ description = "Hotkeys", group = "Awesome"}
	),

	awful.key(
		{ key_mod }, "space", function () menu_main:show() end,
		{ description = "Show Main Menu", group = "Awesome"}
	),

})

--
--- Tail: Misc
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- Head: Layout
--

awful.keyboard.append_global_keybindings({

	awful.key(
		{ key_mod }, "z", function () awful.layout.inc(1) end,
		{ description = "Next Layout", group = "Layout"}
	),

	awful.key(
		{ key_mod, key_shift }, "z", function () awful.layout.inc(-1) end,
		{ description = "Previous Layout", group = "Layout"}
	),

	awful.key(
		{ key_alt }, "k", function () awful.layout.inc(-1) end,
		{ description = "Previous Layout", group = "Layout"}
	),

	awful.key(
		{ key_alt }, "j", function () awful.layout.inc(1) end,
		{ description = "Next Layout", group = "Layout"}
	),



})

--
--- Tail: Layout
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- Head: Tag
--

awful.keyboard.append_global_keybindings({

	awful.key(
		{ key_alt }, "h", awful.tag.viewprev,
		{ description = "Previous Layout", group = "Tag"}
	),

	awful.key(
		{ key_alt }, "l", awful.tag.viewnext,
		{ description = "Next Tag", group = "Tag"}
	),

	awful.key(
		{ key_alt }, "p", awful.tag.history.restore,
		{ description = "Last Tag", group = "Tag"}
	),


	awful.key(
		{ key_alt }, "a", awful.tag.viewprev,
		{ description = "Previous Layout", group = "Tag"}
	),

	awful.key(
		{ key_alt }, "s", awful.tag.viewnext,
		{ description = "Next Tag", group = "Tag"}
	),

	awful.key(
		{ key_alt }, "z", awful.tag.history.restore,
		{ description = "Last Tag", group = "Tag"}
	),

})

--
--- Tail: Tag
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- Head: Client
--

awful.keyboard.append_global_keybindings({

	awful.key(
		{ key_mod }, "k", function () awful.client.focus.byidx(-1) end,
		{ description = "Previous Client", group = "Client"}
	),

	awful.key(
		{ key_mod }, "j", function () awful.client.focus.byidx(1) end,
		{ description = "Next Client", group = "Client"}
	),

	awful.key(
		{ key_mod }, "o",
		function ()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end,
		{ description = "Back Last Client", group = "Client"}
	),


	awful.key(
		{ key_mod }, "a", function () awful.client.focus.byidx(-1) end,
		{ description = "Previous Client", group = "Client"}
	),

	awful.key(
		{ key_mod }, "s", function () awful.client.focus.byidx(1) end,
		{ description = "Next Client", group = "Client"}
	),


	awful.key(
		{ key_mod }, "Tab",
		function ()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end,
		{ description = "Back Last Client", group = "Client"}
	),

})

--
--- Tail: Client
--------------------------------------------------------------------------------


-- General Awesome keys
awful.keyboard.append_global_keybindings({
    -- awful.key({ key_mod,           }, "s",      hotkeys_popup.show_help,
    --           {description="show help", group="awesome"}),
    -- awful.key({ key_mod,           }, "w", function () menu_main:show() end,
    --           {description = "show main menu", group = "awesome"}),
    -- awful.key({ key_mod, "Control" }, "r", awesome.restart,
    --           {description = "reload awesome", group = "awesome"}),
    -- awful.key({ key_mod, "Shift"   }, "q", awesome.quit,
    --           {description = "quit awesome", group = "awesome"}),
    awful.key({ key_mod }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    --awful.key({ key_mod,           }, "Return", function () awful.spawn(terminal) end,
    --          {description = "open a terminal", group = "launcher"}),
    awful.key({ key_mod },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),
    awful.key({ key_mod }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
})

-- Tags related keybindings
-- awful.keyboard.append_global_keybindings({
--     awful.key({ key_mod,           }, "Left",   awful.tag.viewprev,
--               {description = "view previous", group = "tag"}),
--     awful.key({ key_mod,           }, "Right",  awful.tag.viewnext,
--               {description = "view next", group = "tag"}),
--     awful.key({ key_mod,           }, "Escape", awful.tag.history.restore,
--               {description = "go back", group = "tag"}),
-- })

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
    -- awful.key({ key_mod,           }, "j",
    --     function ()
    --         awful.client.focus.byidx( 1)
    --     end,
    --     {description = "focus next by index", group = "client"}
    -- ),
    -- awful.key({ key_mod,           }, "k",
    --     function ()
    --         awful.client.focus.byidx(-1)
    --     end,
    --     {description = "focus previous by index", group = "client"}
    -- ),
    -- awful.key({ key_mod,           }, "Tab",
    --     function ()
    --         awful.client.focus.history.previous()
    --         if client.focus then
    --             client.focus:raise()
    --         end
    --     end,
    --     {description = "go back", group = "client"}),
    awful.key({ key_mod, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ key_mod, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ key_mod, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:activate { raise = true, context = "key.unminimize" }
                  end
              end,
              {description = "restore minimized", group = "client"}),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ key_mod, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ key_mod, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ key_mod,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ key_mod,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ key_mod,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ key_mod, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ key_mod, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ key_mod, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ key_mod, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    -- awful.key({ key_mod,           }, "space", function () awful.layout.inc( 1)                end,
    --           {description = "select next", group = "layout"}),
    -- awful.key({ key_mod, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
    --           {description = "select previous", group = "layout"}),
})


awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { key_mod },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    awful.key {
        modifiers   = { key_mod, "Control" },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },
    awful.key {
        modifiers = { key_mod, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { key_mod, "Control", "Shift" },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    }
})

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ key_mod }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({ key_mod }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    })
end)

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ key_mod,           }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "toggle fullscreen", group = "client"}),
        awful.key({ key_mod, "Shift"   }, "c",      function (c) c:kill()                         end,
                {description = "close", group = "client"}),
        awful.key({ key_mod, "Control" }, "space",  awful.client.floating.toggle                     ,
                {description = "toggle floating", group = "client"}),
        awful.key({ key_mod, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
                {description = "move to master", group = "client"}),
        awful.key({ key_mod,           }, "o",      function (c) c:move_to_screen()               end,
                {description = "move to screen", group = "client"}),
        awful.key({ key_mod,           }, "t",      function (c) c.ontop = not c.ontop            end,
                {description = "toggle keep on top", group = "client"}),
        awful.key({ key_mod,           }, "n",
            function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end ,
            {description = "minimize", group = "client"}),
        awful.key({ key_mod,           }, "m",
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end ,
            {description = "(un)maximize", group = "client"}),
        awful.key({ key_mod, "Control" }, "m",
            function (c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end ,
            {description = "(un)maximize vertically", group = "client"}),
        awful.key({ key_mod, "Shift"   }, "m",
            function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end ,
            {description = "(un)maximize horizontally", group = "client"}),
    })
end)

-- }}}

-- {{{ Rules
-- Rules to apply to new clients.
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { focus = awful.client.focus.filter,
                     raise = true,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Titlebars
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = {
        awful.button({ }, 1, function()
            c:activate { context = "titlebar", action = "mouse_move"  }
        end),
        awful.button({ }, 3, function()
            c:activate { context = "titlebar", action = "mouse_resize"}
        end),
    }

    awful.titlebar(c).widget = {
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
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)
-- }}}



--------------------------------------------------------------------------------
--- Head: Autorun
--

-- https://www.ubuntu-tw.org/modules/newbb/viewtopic.php?post_id=361106#forumpost361106
-- /etc/xdg/autostart/
-- ~/.config/autostart

-- Autorun programs
autorun = true
apps_autorun = {


	-- ## input methond
	'fcitx',

	-- ## policykit
	-- $ apt-cache serch policykit
	'/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1',
	-- 'mate-polkit',

	-- ## volume-control
	--'volumeicon',
	'mate-volume-control-applet',

	-- ## network
	--'nm-applet',
	'nm-tray',

	--'blueman-applet',
}
if autorun then
	for app = 1, #apps_autorun do
		awful.util.spawn(apps_autorun[app])
	end
end
--
--- Tail: Autorun
--------------------------------------------------------------------------------
