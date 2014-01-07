run_or_raise = require("lib/run_or_raise")


root.buttons(join(
	awful.button({ }, 1, function() my_mainmenu:hide() end),
	awful.button({ }, 3, function() my_mainmenu:toggle() end),
	awful.button({ }, 4, awful.tag.viewprev),
	awful.button({ }, 5, awful.tag.viewnext)
))


function moveresize_abs(left, y, w, c)
	c.maximized_horizontal = false
	c.maximized_vertical = false
	local g = c:geometry()
    local scr = screen[c.screen].workarea
	if w == 0 then w = g.width end
	if w < 1 then w = scr.width * w end
    local x = (left == 1) and 0 or scr.width - w
	awful.client.moveresize(-g.x + scr.x + x, -g.y + scr.y + y,
						-g.width + w, -g.height + scr.height, c)
end

config.global = join(
	config.global,
	awful.key({ modkey }, "n", function() awful.screen.focus_relative(1) end),
	awful.key({ modkey }, "u", awful.client.urgent.jumpto),

	-- Layout manipulation for tiling
	awful.key({ modkey,           }, "space", function() awful.layout.inc(config.layouts,  1) end),
	awful.key({ modkey, "Shift"   }, "space", function() awful.layout.inc(config.layouts, -1) end),
	awful.key({ modkey }, "l",     function() awful.tag.incmwfact( 0.05)    end),
	awful.key({ modkey }, "h",     function() awful.tag.incmwfact(-0.05)    end),

	awful.key({ modkey }, "Next",  function () awful.client.moveresize( 20,  20, -40, -40) end),
    awful.key({ modkey }, "Prior", function () awful.client.moveresize(-20, -20,  40,  40) end),

	awful.key({modkey, }, ";", function()
		local c = client.focus
		moveresize_abs(1, 0, 0.5, c)
	end),
	awful.key({modkey, }, "'", function()
		local c = client.focus
		moveresize_abs(0, 0, 0.5, c)
	   end),

	awful.key({modkey, "Shift"}, "'", function()
		keygrabber.run(function(mod, key, event)
		     if event == "release" then return end
		     if     key == 'k'    then awful.client.moveresize(0, -10, 0, 0)
		     elseif key == 'j'    then awful.client.moveresize(0, 10, 0, 0)
		     elseif key == 'l'    then awful.client.moveresize(10, 0, 0, 0)
		     elseif key == 'h'    then awful.client.moveresize(-10, 0, 0, 0)
		     elseif key == ','    then awful.client.moveresize(-30, 0, 0, 0)
		     elseif key == '.'    then awful.client.moveresize(30, 0, 0, 0)
		     elseif key == 'Up'   then awful.client.moveresize(0, -20, 0, 40)
		     elseif key == 'Down' then awful.client.moveresize(0, 10, 0, -20)
		     elseif key == 'Right'then awful.client.moveresize(-20, 0, 40, 0)
		     elseif key == 'Left' then awful.client.moveresize(10, 0, -20, 0)
		     else keygrabber.stop() end
		end)
	end),


	-- toggle sticky for unfocusable object under mouse
	awful.key({ modkey, "Shift"   }, "s",
		function()
			local c = mouse.object_under_pointer()
			if c then c.sticky = not c.sticky end
		end),

	-- big things
	awful.key({ altkey, "Control", "Shift"}, "r", function()
            check = rexec("awesome -k 2>&1")
            if string.find(check, 'syntax OK') then
                awesome.restart()
            else
                notify("Conf Syntax Error!", check)
            end
       end),
	awful.key({ altkey, "Control", "Shift"}, "q", awesome.quit),
	awful.key({ altkey, "Control", "Shift"}, "l", function() exec("slock") end),
	awful.key({ altkey, "Control", "Shift" }, "k", function() exec("xkill") end),
	awful.key({altkey, "Control", "Shift"}, "a", function()
		exec("zsh -c 'cd /tmp\nscrot\n'")
		os.execute("sleep .5")
		notify("Screenshot", "Screenshot saved to /tmp")
	end),

	-- TODO
	-- awful.key({ modkey, "Shift"   }, "x", function() exec('openmsg_tm.py', false) end),

	-- Switching tags
	awful.key({ modkey }, "Left",   awful.tag.viewprev       ),
	awful.key({ modkey }, "Right",  awful.tag.viewnext       ),
	awful.key({ modkey }, "Escape", awful.tag.history.restore),


	-- Switching clients
	awful.key({ modkey }, "j", function()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "k", function()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end),
	awful.key({ altkey,          }, "Tab", function()
		awful.client.focus.byidx(1)
		if client.focus then client.focus:raise() end
	end),
	awful.key({ altkey, "Shift"  }, "Tab", function()
		awful.client.focus.byidx(-1)
		if client.focus then client.focus:raise() end
	end),
	awful.key({ modkey,           }, "Tab", function()
		awful.client.focus.history.previous()
		if client.focus then client.focus:raise() end
	end),

	awful.key({ modkey, }, "d", function()
		local curtags = awful.tag.selectedlist()
		local curtag
		for x, curtag in pairs(curtags) do
            local c
			local clients = curtag:clients()
            local allminimized = true
			for _, c in pairs(clients) do
				if c.minimized == false then
					allminimized = false
					break
                end
			end

			for _, c in pairs(clients) do
				if allminimized == false then
					c.minimized = true
				elseif allminimized == true then
					c.minimized = false
                    client.focus = c
                    c:raise()
				end
			end
		end
	end),

	-- Common program
	awful.key({ modkey,   }, "Return", function() run_or_raise("urxvt -name '" .. TMP_TERM .. "'", {instance = TMP_TERM}) end),
	-- awful.key({ modkey    }, "r",     function() my_promptbox[mouse.screen]:run() end),     -- TODO: change launcher
	awful.key({ modkey    }, "r", function() exec("dmenu_run") end),     -- TODO: change launcher
	awful.key({ modkey,   }, "g", function() exec("sudo gnome-control-center") end),
	-- awful.key({ modkey,           }, "x", function() exec("openmsg.py", false) end),
	awful.key({ modkey,   }, "t", function() exec(terminal) end),
	awful.key({ modkey,   }, "c", function() exec("chromium") end),
	awful.key({ modkey,   }, "f", function() exec("firefox") end),
	awful.key({ modkey,   }, "a", function() exec(home .. "/bin/background/screenshot") end),

	-- htop
	awful.key({ modkey,   }, "z", function()
		if client.focus and client.focus.instance == 'FSTerm' then
			awful.client.movetotag(tags[client.focus.screen][last_tag], client.focus)
		else
			run_or_raise("urxvt -name 'FSTerm' -e 'htop'", { instance = 'FSTerm'})
		end
	end),

	awful.key({ modkey,   }, "q", function()
		local c = client.focus
		if not c then return end
		if c.instance == 'FSTerm' or c.instance == TMP_TERM then
			awful.client.movetotag(tags[c.screen][last_tag], c)
		else
			c:kill()
		end
	end),

	-- sdcv
	awful.key({ altkey, }, "F3", function()
		local new_word = selection()
		if _dict_notify ~= nil then
			naughty.destroy(_dict_notify)
			_dict_notify = nil
			if _old_word == new_word then return end
		end
		_old_word = new_word

		local ans = rexec("sdcv -n --utf8-output '"..new_word.."'")
		_dict_notify = naughty.notify({ text = ans, timeout = 5, width = 1020 })
	end),
	awful.key({ altkey, "Shift"}, "F3", function()
		awful.prompt.run({ prompt = "Dictionary: " }, my_promptbox[mouse.screen].widget,
				   function(words)
					   _old_word = words
					   naughty.notify({ text = words, timeout = 5, width = 1020 })
					   local ans = rexec("sdcv -n --utf8-output '" .. words .. "'")
					   _dict_notify = naughty.notify({ text = ans, timeout = 5, width = 1020 })
				   end)
	end),

	-- yubnub. g;wp;gfl;gi;gm;yt;py;python(search);pypi;rdoc;cppdoc;dbm
	awful.key({ modkey }, "w", function()
		   awful.prompt.run({ prompt = "Web: " }, my_promptbox[mouse.screen].widget,
					  function(command)
						  sexec(browser .. "'http://yubnub.org/parser/parse?command="..command.."'")
					  end)
	   end),

	-- Volume
	awful.key({ }, 'XF86AudioRaiseVolume', function() volumectl("up") end),
	awful.key({ }, 'XF86AudioLowerVolume', function() volumectl("down") end),
	awful.key({ }, 'XF86AudioMute', function() volumectl("mute") end) ,

	awful.key({ }, 'XF86AudioPlay', function() exec("banshee --toggle-playing") end),
	awful.key({ }, 'XF86AudioNext', function() exec("banshee --next") end),
	awful.key({ }, 'XF86AudioPrev', function() exec("banshee --previous") end),
	awful.key({ }, 'XF86AudioStop', function() exec("banshee --stop") end)
)



-- Client Keys/Buttons:   f[[
config.clientkeys = join(
	awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle ),
	awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end),
	awful.key({ modkey, }, "o",    awful.client.movetoscreen ),
	awful.key({ modkey, }, "s",    function(c) c.sticky = not c.sticky end),

	awful.key({ },         "F11",  function(c) c.fullscreen = not c.fullscreen  end),
	awful.key({ modkey, }, "F4",   function(c) c:kill()                         end),
	awful.key({ altkey, }, "F4",   function(c) c:kill()                         end),
	awful.key({ altkey, }, "F12",  function(c) c.above = not c.above            end),
	awful.key({ altkey, }, "F9",   function(c) c.minimized = true end),
	awful.key({ altkey, }, "F10",  function(c)
		c.maximized_horizontal = not c.maximized_horizontal
		c.maximized_vertical   = not c.maximized_vertical
	end)
)

config.clientbuttons = join(
	awful.button({ }, 1, function(c) client.focus = c; c:raise() end),
	awful.button({ modkey }, 1, awful.mouse.client.move),
	awful.button({ modkey }, 3, function(c)
			  c.maximized_horizontal = false
			  c.maximized_vertical = false
			  awful.mouse.client.resize(c, "bottom_right")
		  end))
-- f]]
