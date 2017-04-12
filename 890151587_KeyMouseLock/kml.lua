--[[
KeyMouseLock - 1.1

Toggles a mouse lock on a key/mouse press or hold. Why would you use this? I don't know, but someone wanted it.
Please note that this will not work with any other sensitivity / fov changers and has been made standalone for the sake of minimality. Also due to bugs with setting sensitivity to 0, this addon will set your sensitivity to 0.01 to lock it, so it may not work if you have an extremely high mouse DPI or mouse acceleration.

Usage:
1. Go to Widgets -> KeyMouseLock
2. Make sure the "Visible" box is checked (This enables the widget)
3. Type "bind game [key] ui_keymouselock_toggle 1;+showscores" where [key] is your designated key of course. The +showscores part is a hack which allows for a hold key to be used rather than just a toggle. Note that due to this you can't view the scoreboard while your mouse is locked, but that really doesn't matter.
4. Set Default Sensitivity to your (universal) mouse sensitivity

The Key Input Mode combo box will let you choose whether to use a hold or toggle mode.
The Draw Mouse Lock State box will toggle whether text shows saying "Mouse Locked" when locked.

Please make sure that [key] is not bound to anything else. If it is, you will need to rebind it and add a semicolon. For example if my C key is bound to "say gg" then I would type "bind game c say gg;ui_keymouselock_toggle 1;+showscores" to retain my original bind and include my new bind.
]]

KeyMouseLock = {}

function KeyMouseLock:initialize()
	self.userData = loadUserData()
	CheckSetDefaultValue(self, "userData", "table", {})
	CheckSetDefaultValue(self.userData, "drawState", "boolean", true)
	mspeed = consoleGetVariable("m_speed")
	CheckSetDefaultValue(self.userData, "mouseSpeed", "float", mspeed)
	CheckSetDefaultValue(self.userData, "inputMode", "string", "hold")
	
	widgetCreateConsoleVariable("toggle", "int", 0)
	
	inputModeComboBox = {}
	isLocked = false
	isHeld = false
	cursorHook = "none"
	
	font = "monof55"
end

function KeyMouseLock:getOptionsHeight()
	return 50*9
end

function newline(y,l)
	l = l or 1
	return y + 50*l
end -- increment y in drawOptions

function KeyMouseLock:drawOptions(x,y,intensity)
	local data = self.userData
    local optargs = {intensity = intensity}
	local inputModes = {"hold","toggle"}
	
	i = WIDGET_PROPERTIES_COL_INDENT
	w = WIDGET_PROPERTIES_COL_WIDTH
	
	y = newline(y)
	ui2Label("Please type this into console:",x,y) y = newline(y)
	ui2Label("bind game [key] ui_keymouselock_toggle 1;+showscores", x, y) y = newline(y,2)
	ui2Label("Key Input Mode", x, y) y = newline(y)
	data.inputMode = ui2ComboBox(inputModes, data.inputMode, x, y, i, inputModeComboBox, optargs) y = newline(y,2)
	data.drawState = ui2RowCheckbox(x, y, i, "Draw Mouse Lock State", data.drawState, optargs) y = newline(y)
	data.mouseSpeed = ui2RowSliderEditBox2Decimals(x, y, i, w, 80, "Default Sensitivity", data.mouseSpeed, 0.01, 50.0, optargs)
	
	saveUserData(data)
end	

function unlock(self)
	if isLocked == true then
		consolePerformCommand("-showscores")
		consolePerformCommand("m_speed "..self.userData.mouseSpeed)
		widgetSetConsoleVariable("toggle", 0)
		showScores = false
		isLocked = false
		isHeld = false
	end
end

function lock()
	consolePerformCommand("m_speed 0.01")
	isLocked = true
end

function KeyMouseLock:draw()
	if not shouldShowHUD() then unlock(self) return end
	
	local player = getPlayer()
	local localPlayer = getLocalPlayer()
	if player == nil
		or loading.loadScreenVisible
		or player.state == PLAYER_STATE_EDITOR
		or player.state == PLAYER_STATE_SPECTATOR
		or (playerIndexCameraAttachedTo == playerIndexLocalPlayer and localPlayer.state ~= PLAYER_STATE_INGAME)
		or world.gameState == GAME_STATE_GAMEOVER
		or consoleGetVariable("cl_show_hud") == 0
		or not player.connected
		or isInMenu()
		or replayName == "menu" then
			unlock(self)
			return
	end

	if self.userData.inputMode == "toggle" then
		-- update from cvars
		local cvartoggle = widgetGetConsoleVariable("toggle")
		if cvartoggle == 1 then -- toggle mouse speed
			if isLocked == true then
				unlock(self)
			else
				lock()
			end
			widgetSetConsoleVariable("toggle", 0)
		end
	elseif self.userData.inputMode == "hold" then
		-- update from cvars
		local cvarhold = widgetGetConsoleVariable("toggle")
		if cvarhold == 1 and isHeld == false and showScores then -- on press
			cursorHook = consoleGetVariable("showscorescursorhook")
			consolePerformCommand("showscorescursorhook (none)")
			lock()
			widgetSetConsoleVariable("toggle", 0)
			isHeld = true
		elseif isHeld == true and showScores == false then -- on release
	 		consolePerformCommand("showscorescursorhook " .. cursorHook)
			unlock(self)
		end
	end
	if showScores == true and isLocked == true then -- prevent scoreboard from showing up
		showScores = false
	end
	
	if self.userData.drawState == true then
		if isLocked == true then
			nvgFontSize(24)
			nvgFontFace(font)
			nvgText(-64, -36, "Mouse Locked")
		end
	end
end

registerWidget("KeyMouseLock")
