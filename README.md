# [Reflex-KeyMouseLock](https://steamcommunity.com/sharedfiles/filedetails/?id=890151587)

Toggles a mouse lock on a key/mouse press or hold. Why would you use this? I don't know, but someone requested me to write this.
Please note that this will not work with any other sensitivity / fov changers and has been made standalone for the sake of minimality. Also due to bugs with setting sensitivity to 0, this addon will set your sensitivity to 0.01 to lock it, so it may not work if you have an extremely high mouse DPI or mouse acceleration.

Usage:
1. Go to Widgets -> KeyMouseLock
2. Make sure the "Visible" box is checked (This enables the widget)
3. Type `"bind game [key] ui_keymouselock_toggle 1;+showscores"` where [key] is your designated key of course. The +showscores part is a hack which allows for a hold key to be used rather than just a toggle. Note that due to this you can't view the scoreboard while your mouse is locked, but that really doesn't matter.
4. Set Default Sensitivity to your (universal) mouse sensitivity

The Key Input Mode combo box will let you choose whether to use a hold or toggle mode.
The Draw Mouse Lock State box will toggle whether text shows saying "Mouse Locked" when locked.

Please make sure that [key] is not bound to anything else. If it is, you will need to rebind it and add a semicolon. For example if my C key is bound to "say gg" then I would type `"bind game c say gg;ui_keymouselock_toggle 1;+showscores"` to retain my original bind and include my new bind.
