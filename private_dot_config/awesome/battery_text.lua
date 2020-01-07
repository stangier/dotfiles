local wibox = require("wibox")
local awful = require("awful")

batteryTextWidget = wibox.widget.textbox()

sleepTimer = timer({timeout=30})
sleepTimer:connect_signal("timeout",
	function() 
		awful.util.spawn_with_shell("dbus-send --session --dest=org.naquadah.awesome.awful /com/console/battery_text com.console.battery_text.widget string:$(acpi)")
	end)

sleepTimer:start()
sleepTimer:emit_signal("timeout")

dbus.request_name("session", "com.console.battery_text")
dbus.add_match("session", "interface='com.console.battery_text', member='widget' ")
dbus.connect_signal("com.console.battery_text",
  function (...)
    local data = {...}
    local dbustext = data[2]
    batteryTextWidget:set_text(dbustext)
  end)
