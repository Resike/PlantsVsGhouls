local _, ns = ...
local PlantsVsGhouls = { }

ns.PlantsVsGhouls = PlantsVsGhouls

local math = math
local ipairs = ipairs

local GetCursorPosition = GetCursorPosition
local GetTime = GetTime
local PlaySoundFile = PlaySoundFile

local mainframe = CreateFrame("Frame", nil, UIParent)
mainframe:SetPoint("Center", 0, 0)
mainframe:SetWidth(1500)
mainframe:SetHeight(700)
mainframe:SetAlpha(1)
mainframe:Hide()

local Plants = {
	[1] = {
		[1] = {frame, model},
		[2] = {frame, model},
		[3] = {frame, model},
		[4] = {frame, model},
		[5] = {frame, model},
		[6] = {frame, model},
		[7] = {frame, model},
		[8] = {frame, model},
		[9] = {frame, model}
	},
	[2] = {
		[1] = {frame, model},
		[2] = {frame, model},
		[3] = {frame, model},
		[4] = {frame, model},
		[5] = {frame, model},
		[6] = {frame, model},
		[7] = {frame, model},
		[8] = {frame, model},
		[9] = {frame, model}
	},
	[3] = {
		[1] = {frame, model},
		[2] = {frame, model},
		[3] = {frame, model},
		[4] = {frame, model},
		[5] = {frame, model},
		[6] = {frame, model},
		[7] = {frame, model},
		[8] = {frame, model},
		[9] = {frame, model}
	},
	[4] = {
		[1] = {frame, model},
		[2] = {frame, model},
		[3] = {frame, model},
		[4] = {frame, model},
		[5] = {frame, model},
		[6] = {frame, model},
		[7] = {frame, model},
		[8] = {frame, model},
		[9] = {frame, model}
	},
	[5] = {
		[1] = {frame, model},
		[2] = {frame, model},
		[3] = {frame, model},
		[4] = {frame, model},
		[5] = {frame, model},
		[6] = {frame, model},
		[7] = {frame, model},
		[8] = {frame, model},
		[9] = {frame, model}
	}
}

local PlantTypes = {
	-- Sunflower (764)
	[1] = {model = "Creature\\LasherSunflower\\lasher_sunflower.m2", health = 100, cooldown = 5}
}

local Ghouls = {
	[1] = {frame, model},
	[2] = {frame, model},
	[3] = {frame, model},
	[4] = {frame, model},
	[5] = {frame, model}
}

local GhoulTypes = {
	-- Vanilla Ghoul (508)
	[1] = {model = {[1] = 137, [2] = 414, [3] = 519, [4] = 547}, distance = 4.5772, yaw = - 1.5346, pitch = - 0.9802, startpos = - 170, endpos = - 120, stoppos = - 30, speed = 0.3, damage = 34, health = 100},
	-- Burning Crusade Ghoul
	[2] = {model = {[1] = 24992, [2] = 24993, [3] = 24994, [4] = 24995}, distance = 5.5772, yaw = - 1.5346, pitch = - 0.9802, startpos = - 190, endpos = - 140, stoppos = - 50, speed = 0.4, damage = 41, health = 150},
	-- Burning Crusade Ghoul Spiked
	[3] = {model = {[1] = 28292, [2] = 30656}, distance = 5.5772, yaw = - 1.5346, pitch = - 0.9802, startpos = - 190, endpos = - 140, stoppos = - 50, speed = 0.4, damage = 45, health = 175}
}

local Slots = {
	[1] = {frame, model, cooldown},
	[2] = {frame, model, cooldown},
	[3] = {frame, model, cooldown},
	[4] = {frame, model, cooldown},
	[5] = {frame, model, cooldown}
}

local CurrentLine = nil
local CurrentRow = nil
local CurrentGrid = nil

local CurrentPlant = nil
local CurrentSlot = nil

local CurrentDegree = nil
local CurrentSize = nil

local PlantMode = false
local DestroyMode = false

local ScaleLocked = false

local GamePaused = false

local frame = CreateFrame("Frame", nil, mainframe)
frame:SetPoint("Center", 0, 0)
frame:SetWidth(1400)
frame:SetHeight(600)
frame:SetAlpha(1)
frame:SetMovable(true)

frame:SetScript("OnMouseDown", function(self, button)
	if button == "RightButton" then
		if PlantMode then
			PlantMode = false
			PlantsVsGhouls:ClearTemp()
			PlantsVsGhouls:ClearCursorTemp()
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\tap.ogg", "Master")
		elseif DestroyMode then
			DestroyMode = false
			PlantsVsGhouls:ClearCursorTemp()
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\tap.ogg", "Master")
		end
	elseif button == "LeftButton" then
		PlantsVsGhouls:FrameMouseDown(self, button)
	end
end)

frame:SetScript("OnMouseUp", function(self, button)
	if button == "LeftButton" then
		PlantsVsGhouls:FrameMouseUp(self, button)
	end
end)

local map = frame:CreateTexture(nil, "Background")
map:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\background1unsodded.tga")
map:SetWidth(1400)
map:SetHeight(600)
map:SetAlpha(1)
map:SetBlendMode("Disable")
map:SetDrawLayer("Background", 0)
map:SetAllPoints(frame)

local sod1line = frame:CreateTexture(nil, "Background")
sod1line:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\sod1line.tga")
sod1line:SetWidth(766)
sod1line:SetHeight(118)
sod1line:SetAlpha(0.99)
sod1line:SetBlendMode("Disable")
sod1line:SetDrawLayer("Background", 2)
sod1line:SetPoint("Left", frame, "Left", 240, - 15)

local sodendcap = frame:CreateTexture(nil, "Background")
sodendcap:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\sodendcap.tga")
sodendcap:SetSize(72 * math.sqrt(2), 72 * math.sqrt(2))
sodendcap:SetRotation(math.rad(0))
sodendcap:SetAlpha(0.99)
sodendcap:SetBlendMode("Disable")
sodendcap:SetDrawLayer("Background", 6)
sodendcap:SetPoint("Bottom", sod1line, "BottomRight", 0, - 10)
sodendcap:Hide()

local sodend = frame:CreateTexture(nil, "Background")
sodend:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\sodend.tga")
sodend:SetWidth(55)
sodend:SetHeight(100)
sodend:SetAlpha(0.99)
sodend:SetBlendMode("Disable")
sodend:SetDrawLayer("Background", 4)
sodend:SetPoint("Bottom", sodendcap, "Center", 0, 0)
sodend:Hide()

local frametimer = 0
local percentCompleted = 0

function PlantsVsGhouls:FrameOnUpdate(elapsed)
	frametimer = frametimer + elapsed
	if frametimer < 0.005 then
		return
	end
	frametimer = 0
	local size = 766
	percentCompleted = percentCompleted + 0.004
	if percentCompleted >= 1 then
		sodendcap:Hide()
		sodend:Hide()
		sodendcap:SetSize(72 * math.sqrt(2), 72 * math.sqrt(2))
		sodend:SetWidth(60)
		frame:SetScript("OnUpdate", nil)
	else
		sodendcap:Show()
		sodend:Show()
		sodendcap:SetSize(sodendcap:GetWidth() * (1 - (percentCompleted / 150)), sodendcap:GetHeight() * (1 - (percentCompleted / 150)))
		sodendcap:SetRotation(math.rad(0 + (percentCompleted * - 2000)))
		sodend:SetWidth(sodend:GetWidth() * (1 - (percentCompleted / 150)))
		sod1line:SetWidth(size * percentCompleted)
		sod1line:SetTexCoord(0, 0 + percentCompleted, 0, 1)
	end
end

--[[local sod3line = frame:CreateTexture(nil, "Background")
sod3line:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\sod3line.tga")
sod3line:SetWidth(766)
sod3line:SetHeight(118)
sod3line:SetAlpha(0.99)
sod3line:SetBlendMode("Disable")
sod3line:SetDrawLayer("Background", 2)
sod3line:SetPoint("Left", frame, "Left", 240, - 15)
sod3line:Hide()]]

local Backdrop = {
	--edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
	edgeSize = 10,
	insets = {
		left = 11,
		right = 11,
		top = 11,
		bottom = 11
	}
}

local SlotBackdrop = {
	bgFile = "Interface\\Buttons\\White8x8.blp",
	--[[edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
	edgeSize = 0,
	insets = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0
	}]]
}

local sun = CreateFrame("Frame", nil, frame)
sun:SetPoint("TopLeft", map, "TopLeft", 25, 0)
sun:SetWidth(150)
sun:SetHeight(150)
sun:SetAlpha(1)
sun:SetBackdrop(SlotBackdrop)
sun:SetBackdropColor(0, 0, 0, 0.5)

local sunmodel = CreateFrame("PlayerModel", nil, frame)

function PlantsVsGhouls:InitSunModel()
	sunmodel:SetModel("Spells\\druid_wrath_missile_v2.m2")
	sunmodel:SetAlpha(1)
	sunmodel:SetPosition(3, 0, 1.35)
	sunmodel:SetAllPoints(sun)
	sunmodel.value = 25
end

local cursortempframe = CreateFrame("Frame", nil, UIParent)
cursortempframe:SetFrameStrata("Dialog")
cursortempframe:SetFrameLevel(0)
cursortempframe:SetAlpha(1)
cursortempframe:SetAllPoints(UIParent)

local cursortemp = CreateFrame("PlayerModel", nil, cursortempframe)

function PlantsVsGhouls:CreateCursorTemp()
	if PlantMode then
		cursortemp:SetModel(PlantTypes[CurrentPlant].model)
		cursortemp:SetAlpha(1)
		cursortemp:SetCustomCamera(1)
		CurrentDegree = math.random(0, 45)
		CurrentSize = 200 + math.random(0, 30)
		cursortemp:SetWidth(CurrentSize)
		cursortemp:SetHeight(CurrentSize)
		cursortemp:SetRotation(math.rad(CurrentDegree))
		self:SetModelTilt(cursortemp, 55)
	elseif DestroyMode then
		cursortemp:SetModel("World\\Generic\\goblin\\passivedoodads\\kezan\\items\\goblin_beachshovel_02.m2")
		cursortemp:SetAlpha(1)
		cursortemp:SetWidth(125)
		cursortemp:SetHeight(125)
		cursortemp:SetPosition(6.20, 0.03, 2.70)
		cursortemp:SetRotation(math.rad(128))
	end
end

function PlantsVsGhouls:ClearCursorTemp()
	cursortemp:ClearModel()
end

local temp = CreateFrame("PlayerModel", nil, frame)

function PlantsVsGhouls:CreateTemp(frame, model)
	if PlantMode and Plants[CurrentLine][CurrentRow].model.type == nil then
		temp:SetModel(PlantTypes[CurrentPlant].model)
		temp:SetPoint("Center", frame, "TopLeft", frame.x, - frame.y)
		temp:SetAlpha(0.7)
		temp:SetCustomCamera(1)
		Plants[CurrentLine][CurrentRow].model.degree = CurrentDegree
		Plants[CurrentLine][CurrentRow].model.size = CurrentSize
		temp:SetWidth(Plants[CurrentLine][CurrentRow].model.size)
		temp:SetHeight(Plants[CurrentLine][CurrentRow].model.size)
		temp:SetRotation(math.rad(Plants[CurrentLine][CurrentRow].model.degree))
		self:SetModelTilt(temp, 55)
	end
end

function PlantsVsGhouls:ClearTemp()
	temp:ClearModel()
end

for i = 1, 5 do
	Slots[i].frame = CreateFrame("Frame", nil, frame)
	if i == 1 then
		Slots[i].frame:SetPoint("Top", sun, "Bottom", 0, 0)
	else
		Slots[i].frame:SetPoint("Top", Slots[i - 1].frame, "Bottom", 0, 0)
	end
	Slots[i].frame:SetWidth(120)
	Slots[i].frame:SetHeight(60)
	Slots[i].frame:SetAlpha(1)
	Slots[i].frame:SetBackdrop(SlotBackdrop)
	Slots[i].frame:SetBackdropColor(0.5, 0.5, 0.5, 0.5)
	Slots[i].model = CreateFrame("PlayerModel", nil, frame)
	Slots[i].model:SetAllPoints(Slots[i].frame)
	Slots[i].cooldown = CreateFrame("Cooldown", nil, Slots[i].frame)
	Slots[i].cooldown:SetPoint("TOPLEFT", Slots[i].frame, "TOPLEFT", 0, 0)
	Slots[i].cooldown:SetWidth(120)
	Slots[i].cooldown:SetHeight(61)
	Slots[i].model:SetScript("OnMouseDown", function(self, button)
		PlantsVsGhouls:SlotOnMouseDown(button, Slots[i].model, Slots[i].cooldown)
	end)
end

local slotx = CreateFrame("Frame", nil, frame)
slotx:SetPoint("Top", Slots[5].frame, "Bottom", 0, 0)
slotx:SetWidth(120)
slotx:SetHeight(60)
slotx:SetAlpha(1)
slotx:SetBackdrop(SlotBackdrop)
slotx:SetBackdropColor(0.5, 0.5, 0.5, 0.5)

local modelslotx = CreateFrame("PlayerModel", nil, frame)

function PlantsVsGhouls:InitModelSlotX()
	modelslotx:SetModel("World\\Generic\\goblin\\passivedoodads\\kezan\\items\\goblin_beachshovel_02.m2")
	modelslotx:SetAlpha(1)
	modelslotx:SetPosition(6.20, 0.03, 2.70)
	modelslotx:SetRotation(math.rad(128))
	modelslotx:SetAllPoints(slotx)
end
PlantsVsGhouls:InitModelSlotX()

modelslotx:SetScript("OnMouseDown", function(self, button)
	if not GamePaused then
		PlantMode = false
		DestroyMode = not DestroyMode
		if DestroyMode then
			--PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\shovel.ogg", "Master")
		else
			PlantsVsGhouls:DisableModes()
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\tap.ogg", "Master")
		end
		PlantsVsGhouls:CreateCursorTemp()
		cursortemp:SetScript("OnUpdate", PlantsVsGhouls.CursorOnUpdate)
	end
end)

function PlantsVsGhouls:CursorOnUpdate(elapsed)
	local x, y = GetCursorPosition()
	local scale = 1 / UIParent:GetEffectiveScale()
	if PlantMode then
		cursortemp:SetPoint("Center", UIParent, "BottomLeft", x * scale, y * scale)
	elseif DestroyMode then
		cursortemp:SetPoint("Center", UIParent, "BottomLeft", x * scale + (cursortemp:GetWidth() * 0.55), y * scale + (cursortemp:GetHeight() * 0.12))
	end
end

for i = 1, 5 do
	for j = 1, 9 do
		Plants[i][j].frame = CreateFrame("Frame", nil, frame)
		if i == 1 and j == 1 then
			Plants[i][j].frame:SetPoint("TopLeft", frame, "TopLeft", 256, - 81)
		elseif (i == 2 and j == 1) or (i == 3 and j == 1) or (i == 4 and j == 1) or (i == 5 and j == 1) then
			Plants[i][j].frame:SetPoint("Top", Plants[i - 1][j].frame, "Bottom", 0, 0)
		else
			Plants[i][j].frame:SetPoint("BottomLeft", Plants[i][j - 1].frame, "BottomRight", 0, 0)
		end
		Plants[i][j].frame:SetWidth(80)
		if i == 1 then
			if j == 1 then
				Plants[i][j].frame:SetHeight(95)
			elseif j == 2 then
				Plants[i][j].frame:SetHeight(100)
			elseif j == 3 then
				Plants[i][j].frame:SetHeight(105)
			elseif j == 4 then
				Plants[i][j].frame:SetHeight(110)
			elseif j == 5 then
				Plants[i][j].frame:SetHeight(110)
			elseif j == 6 then
				Plants[i][j].frame:SetHeight(110)
			elseif j == 7 then
				Plants[i][j].frame:SetHeight(105)
			elseif j == 8 then
				Plants[i][j].frame:SetHeight(100)
			elseif j == 9 then
				Plants[i][j].frame:SetHeight(95)
			end
		else
			Plants[i][j].frame:SetHeight(98)
		end
		Plants[i][j].frame:SetAlpha(1)
		Plants[i][j].frame:SetBackdrop(Backdrop)
		Plants[i][j].frame.x = Plants[i][j].frame:GetWidth() / 2
		Plants[i][j].frame.y = Plants[i][j].frame:GetHeight() / 3
		Plants[i][j].model = CreateFrame("PlayerModel", nil, Plants[i][j].frame)
		Plants[i][j].frame:SetScript("OnEnter", function(self)
			PlantsVsGhouls:OnEnter(self, i, j, Plants[i][j].model)
		end)
		Plants[i][j].frame:SetScript("OnLeave", function(self)
			PlantsVsGhouls:OnLeave(Plants[i][j].model)
		end)
		Plants[i][j].frame:SetScript("OnMouseDown", function(self, button)
			PlantsVsGhouls:OnMouseDown(button, Plants[i][j].model)
		end)
	end
end

for i = 1, 5 do
	Ghouls[i].frame = CreateFrame("Frame", nil, frame)
	Ghouls[i].frame:SetFrameStrata("High")
	Ghouls[i].frame:SetPoint("Right", Plants[i][1].frame, "Right", 900, 15)
	Ghouls[i].frame:SetAlpha(1)
	Ghouls[i].frame:SetWidth(200)
	Ghouls[i].frame:SetHeight(200)
	Ghouls[i].model = CreateFrame("PlayerModel", nil, Ghouls[i].frame)
	Ghouls[i].model:SetAllPoints(Ghouls[i].frame)
end

function PlantsVsGhouls:SlotOnMouseDown(button, model, cooldown)
	if not GamePaused and (not cooldown.start or GetTime() > (cooldown.start + PlantTypes[model.type].cooldown)) then
		DestroyMode = false
		PlantMode = not PlantMode
		if PlantMode then
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\seedlift.ogg", "Master")
		else
			PlantsVsGhouls:DisableModes()
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\tap.ogg", "Master")
		end
		CurrentPlant = model.type
		CurrentSlot = cooldown
		PlantsVsGhouls:CreateCursorTemp()
		cursortemp:SetScript("OnUpdate", PlantsVsGhouls.CursorOnUpdate)
	else
		PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\buzzer.ogg", "Master")
	end
end

function PlantsVsGhouls:InitModelSlots(model, type)
	model:SetModel(PlantTypes[type].model)
	model.type = type
	model:SetAlpha(1)
	model:SetCamera(0)
end
for i = 1, 5 do
	PlantsVsGhouls:InitModelSlots(Slots[i].model, 1)
end

function PlantsVsGhouls:OnEnter(self, line, row, model)
	CurrentGrid = self
	CurrentLine = line
	CurrentRow = row
	if PlantMode and Plants[CurrentLine][CurrentRow].model.type == nil then
		PlantsVsGhouls:CreateTemp(self, model)
	elseif DestroyMode then
		model:SetLight(1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1)
	end
end

function PlantsVsGhouls:OnLeave(model)
	CurrentGrid = nil
	CurrentLine = nil
	CurrentRow = nil
	if PlantMode then
		temp:ClearModel()
	elseif DestroyMode then
		model:SetLight(1, 0, 0, 1, 0, 1, 0.7, 0.7, 0.7, 1, 0.8, 0.8, 0.64)
	end
end

function PlantsVsGhouls:OnMouseDown(button, model)
	if button == "LeftButton" then
		if PlantMode then
			self:CreatePlant(model)
		elseif DestroyMode then
			self:DestroyPlant(model, CurrentLine, CurrentRow)
		end
	else
		if PlantMode then
			PlantsVsGhouls:DisableModes()
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\tap.ogg", "Master")
		elseif DestroyMode then
			PlantsVsGhouls:DisableModes()
			model:SetLight(1, 0, 0, 1, 0, 1, 0.7, 0.7, 0.7, 1, 0.8, 0.8, 0.64)
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\tap.ogg", "Master")
		end
	end
end

function PlantsVsGhouls:CreatePlant(model)
	if PlantMode and Plants[CurrentLine][CurrentRow].model.type == nil then
		Plants[CurrentLine][CurrentRow].model.time = GetTime()
		Plants[CurrentLine][CurrentRow].model.type = CurrentPlant
		Plants[CurrentLine][CurrentRow].model.health = PlantTypes[CurrentPlant].health
		CurrentSlot:SetCooldown(GetTime(), PlantTypes[CurrentPlant].cooldown)
		CurrentSlot.start = GetTime()
		self:InitModelPlants(model, CurrentLine, CurrentRow)
		PlantsVsGhouls:DisableModes()
		cursortemp:SetScript("OnUpdate", nil)
		PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\plant.ogg", "Master")
	end
end

function PlantsVsGhouls:InitModelPlants(model, line, row)
	if Plants[line][row].model.type ~= nil then
		model:SetModel(PlantTypes[CurrentPlant].model)
		model:SetPoint("Center", Plants[line][row].frame, "TopLeft", Plants[line][row].frame.x, - Plants[line][row].frame.y)
		model:SetAlpha(1)
		model:SetCustomCamera(1)
		model:SetWidth(Plants[line][row].model.size)
		model:SetHeight(Plants[line][row].model.size)
		model:SetRotation(math.rad(Plants[line][row].model.degree))
		self:SetModelTilt(model, 55)
		self:ChangePlantAnimation(model, 2)
	end
end

function PlantsVsGhouls:DestroyPlant(model, line, row, kill)
	if Plants[line][row].model.type ~= nil then
		if not kill then
			Plants[line][row].model.type = nil
			Plants[line][row].model.health = nil
		end
		model:SetLight(1, 0, 0, 1, 0, 1, 0.7, 0.7, 0.7, 1, 0.8, 0.8, 0.64)
		model:ClearModel()
		if not kill then
			PlantsVsGhouls:DisableModes()
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\shovel.ogg", "Master")
		end
	end
end

function PlantsVsGhouls:SetModelColor(model, color)
	if not model then
		return
	end
	if not color then
		model:SetLight(1, 0, 0, 1, 0, 1, 0.7, 0.7, 0.7, 1, 0.8, 0.8, 0.64) -- Base
	elseif color == "BaseGlow" then
		model:SetLight(1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1) -- BaseGlow
	elseif color == "Red" then
		model:SetLight(1, 0, 0, 1, 0, 1, 1, 0.5, 0.5, 1, 1, 0.5, 0.5) -- Red
	elseif color == "RedGlow" then
		model:SetLight(1, 0, 0, 1, 0, 1, 1, 0.3, 0.3, 1, 1, 0.3, 0.3) -- RedGlow
	elseif color == "Blue" then
		model:SetLight(1, 0, 0, 1, 0, 1, 0.3, 0.3, 1, 1, 0.3, 0.3, 1) -- Blue
	end
end

function PlantsVsGhouls:GetNextPlant(model, maxrow)
	if not model then
		return
	end
	for i = 1, maxrow do
		if Plants[model.line][i].model.type ~= nil then
			model.next = i
		end
	end
end

function PlantsVsGhouls:ChangePlantAnimation(model, anim)
	if anim and anim > - 1 and anim < 802 then
		local elapsed = 0
		model:SetScript("OnUpdate", function(model, elaps)
			if not GamePaused then
				elapsed = elapsed + (elaps * 600)
				model:SetSequenceTime(anim, elapsed)
			else
				model:SetSequenceTime(anim, elapsed)
			end
		end)
	end
end

function PlantsVsGhouls:ChangeGhoulAnimation(model, anim)
	if anim and anim > - 1 and anim < 802 then
		local elapsed = 0
		local time = 0
		model:SetScript("OnUpdate", function(model, elaps)
			if not GamePaused then
				elapsed = elapsed + (elaps * 600)
				model:SetSequenceTime(anim, elapsed)
				if anim == 5 then
					Ghouls[model.line].frame:SetPoint("Right", Plants[model.line][1].frame, "Right", model.pos, 15)
					if self:GetDistance(Plants[model.line][9].frame, model) > model.startpos and self:GetDistance(Plants[model.line][9].frame, model) < model.endpos and Plants[model.line][9].model.type ~= nil then
						self:ChangeGhoulAnimation(model, 61)
					elseif self:GetDistance(Plants[model.line][8].frame, model) > model.startpos and self:GetDistance(Plants[model.line][8].frame, model) < model.endpos and Plants[model.line][8].model.type ~= nil then
						self:ChangeGhoulAnimation(model, 61)
					elseif self:GetDistance(Plants[model.line][7].frame, model) > model.startpos and self:GetDistance(Plants[model.line][7].frame, model) < model.endpos and Plants[model.line][7].model.type ~= nil then
						self:ChangeGhoulAnimation(model, 61)
					elseif self:GetDistance(Plants[model.line][6].frame, model) > model.startpos and self:GetDistance(Plants[model.line][6].frame, model) < model.endpos and Plants[model.line][6].model.type ~= nil then
						self:ChangeGhoulAnimation(model, 61)
					elseif self:GetDistance(Plants[model.line][5].frame, model) > model.startpos and self:GetDistance(Plants[model.line][5].frame, model) < model.endpos and Plants[model.line][5].model.type ~= nil then
						self:ChangeGhoulAnimation(model, 61)
					elseif self:GetDistance(Plants[model.line][4].frame, model) > model.startpos and self:GetDistance(Plants[model.line][4].frame, model) < model.endpos and Plants[model.line][4].model.type ~= nil then
						self:ChangeGhoulAnimation(model, 61)
					elseif self:GetDistance(Plants[model.line][3].frame, model) > model.startpos and self:GetDistance(Plants[model.line][3].frame, model) < model.endpos and Plants[model.line][3].model.type ~= nil then
						self:ChangeGhoulAnimation(model, 61)
					elseif self:GetDistance(Plants[model.line][2].frame, model) > model.startpos and self:GetDistance(Plants[model.line][2].frame, model) < model.endpos and Plants[model.line][2].model.type ~= nil then
						self:ChangeGhoulAnimation(model, 61)
					elseif self:GetDistance(Plants[model.line][1].frame, model) > model.startpos and self:GetDistance(Plants[model.line][1].frame, model) < model.endpos and Plants[model.line][1].model.type ~= nil then
						self:ChangeGhoulAnimation(model, 61)
					end
					if model.pos > model.stoppos then
						model.pos = model.pos - model.speed
					else
						self:ChangeGhoulAnimation(model, 8)
						--model:SetScript("OnUpdate", nil)
					end
				elseif anim == 61 then
					time = time + (elaps * 1000)
					if time > 800 and Plants[model.line][model.next].model.health and Plants[model.line][model.next].model.health > 0 then
						if not DestroyMode or (DestroyMode and (CurrentLine ~= model.line or CurrentRow ~= model.next)) then
							self:SetModelColor(Plants[model.line][model.next].model, "Red")
						elseif DestroyMode and CurrentLine == model.line and CurrentRow == model.next then
							self:SetModelColor(Plants[model.line][model.next].model, "RedGlow")
						end
					else
						if not DestroyMode or (DestroyMode and (CurrentLine ~= model.line or CurrentRow ~= model.next)) then
							self:SetModelColor(Plants[model.line][model.next].model)
						elseif DestroyMode and CurrentLine == model.line and CurrentRow == model.next then
							self:SetModelColor(Plants[model.line][model.next].model, "BaseGlow")
						end
					end
					if time > 1000 and Plants[model.line][model.next].model.health then
						time = 0
						if Plants[model.line][model.next].model.health > 0 then
							Plants[model.line][model.next].model.health = Plants[model.line][model.next].model.health - model.damage
							local r = math.random(3)
							if r == 1 then
								r = ""
							elseif r == 3 then
								r = "soft"
							end
							PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\chomp"..r..".ogg", "Master")
						else
							Plants[model.line][model.next].model.type = nil
						end
					end
					if Plants[model.line][model.next].model.health and Plants[model.line][model.next].model.health <= 0 then
						self:DestroyPlant(Plants[model.line][model.next].model, model.line, model.next, true)
					end
					if Plants[model.line][model.next].model.type == nil then
						if self:GetDistance(Plants[model.line][2].frame, model) < model.startpos then
							self:GetNextPlant(model, 1)
						elseif self:GetDistance(Plants[model.line][3].frame, model) < model.startpos then
							self:GetNextPlant(model, 2)
						elseif self:GetDistance(Plants[model.line][4].frame, model) < model.startpos then
							self:GetNextPlant(model, 3)
						elseif self:GetDistance(Plants[model.line][5].frame, model) < model.startpos then
							self:GetNextPlant(model, 4)
						elseif self:GetDistance(Plants[model.line][6].frame, model) < model.startpos then
							self:GetNextPlant(model, 5)
						elseif self:GetDistance(Plants[model.line][7].frame, model) < model.startpos then
							self:GetNextPlant(model, 6)
						elseif self:GetDistance(Plants[model.line][8].frame, model) < model.startpos then
							self:GetNextPlant(model, 7)
						elseif self:GetDistance(Plants[model.line][9].frame, model) < model.startpos then
							self:GetNextPlant(model, 8)
						end
						self:ChangeGhoulAnimation(model, 5)
					end
				end
			else
				model:SetSequenceTime(anim, elapsed)
			end
		end)
	end
end

function PlantsVsGhouls:InitModelGhouls(model, type, createdline)
	model.line = createdline
	model.next = 9
	model.pos = 900 + math.random(50, 150)
	local r = math.random((#GhoulTypes[type].model))
	model:SetDisplayInfo(GhoulTypes[type].model[r])
	model.distance = GhoulTypes[type].distance
	model.yaw = GhoulTypes[type].yaw
	model.pitch = GhoulTypes[type].pitch
	model.startpos = GhoulTypes[type].startpos
	model.endpos = GhoulTypes[type].endpos
	model.stoppos = GhoulTypes[type].stoppos
	model.speed = GhoulTypes[type].speed
	model.damage = GhoulTypes[type].damage
	model:SetWidth(200)
	model:SetHeight(200)
	model:SetAlpha(1)
	model:SetCustomCamera(1)
	model:SetRotation(math.rad(0))
	self:SetOrientation(model, model.distance, model.yaw, model.pitch)
	self:ChangeGhoulAnimation(model, 5)
end

function PlantsVsGhouls:GetDistance(obj1, obj2)
	return obj2:GetLeft() - (obj1:GetLeft() + obj1:GetWidth())
end

function PlantsVsGhouls:GetBaseCameraTarget(model)
	local modelfile = model:GetModel()
	if modelfile and modelfile ~= "" then
		local tempmodel = CreateFrame("PlayerModel", nil, UIParent)
		tempmodel:SetModel(modelfile)
		tempmodel:SetCustomCamera(1)
		local x, y, z = tempmodel:GetCameraTarget()
		tempmodel:ClearModel()
		return x, y, z
	end
end

function PlantsVsGhouls:SetOrientation(model, distance, yaw, pitch)
	if model:HasCustomCamera() then
		local x = distance * math.cos(yaw) * math.cos(pitch)
		local y = distance * math.sin(- yaw) * math.cos(pitch)
		local z = (distance * math.sin(- pitch))
		model:SetCameraPosition(x, y, z)
	end
end

function PlantsVsGhouls:SetModelTilt(model, tiltdegree)
	if model:HasCustomCamera() then
		local x, y, z = model:GetCameraPosition()
		local r = math.sqrt((x * x) + (y * y) + (z * z))
		local xx = math.sin(math.rad(tiltdegree)) * r
		local zz = math.cos(math.rad(tiltdegree)) * r
		if xx > 0.1 then
			model:SetCameraPosition(xx, y, zz)
		else
			model:SetCameraPosition(0.1, y, zz)
		end
	end
	local x, y, z = self:GetBaseCameraTarget(model)
	if y and z then
		model:SetCameraTarget(0, y, z)
	end
end

function PlantsVsGhouls:FrameMouseDown(frame, button)
	if button == "LeftButton" then
		frame:StartMoving()
	end
end

function PlantsVsGhouls:FrameMouseUp(frame, button)
	frame:StopMovingOrSizing()
end

function PlantsVsGhouls:DisableModes()
	self:ClearCursorTemp()
	self:ClearTemp()
	PlantMode = false
	DestroyMode = false
end

local pause = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
pause:SetPoint("Top", frame, "Top", 225, 0)
pause:SetWidth(100)
pause:SetHeight(25)
pause:SetText("Pause")
pause:SetScript("OnClick", function(self, button)
	if button == "LeftButton" then
		PlantsVsGhouls:TogglePause(self)
	end
end)

function PlantsVsGhouls:TogglePause(frame)
	if GamePaused then
		self:ResumeGame()
		frame:SetText("Pause")
		GamePaused = false
	else
		self:PauseGame()
		frame:SetText("Resume")
		GamePaused = true
	end
end

function PlantsVsGhouls:PauseGame()
	self:DisableModes()
	self:ClearCursorTemp()
	PlantsVsGhouls:ClearTemp()
	local time = GetTime()
	for i = 1, 5 do
		Slots[i].cooldown:Hide()
		if Slots[i].cooldown.start and time <= (Slots[i].cooldown.start + PlantTypes[Slots[i].model.type].cooldown) then
			Slots[i].cooldown.remains = PlantTypes[Slots[i].model.type].cooldown - (time - Slots[i].cooldown.start)
		end
	end
end

function PlantsVsGhouls:ResumeGame()
	local time = GetTime()
	for i = 1, 5 do
		Slots[i].cooldown:Show()
		if Slots[i].cooldown.start and time <= (Slots[i].cooldown.start + PlantTypes[Slots[i].model.type].cooldown) then
			Slots[i].cooldown:SetCooldown(time, Slots[i].cooldown.remains)
			Slots[i].cooldown.start = time - (PlantTypes[Slots[i].model.type].cooldown - Slots[i].cooldown.remains)
		end
	end
end

function PlantsVsGhouls:InitAll()
	--self:ResizeFrame(frame)
	self:InitSunModel()
	for i = 1, 5 do
		self:InitModelSlots(Slots[i].model, 1)
	end
	self:InitModelSlotX()
	for i = 1, 5 do
		for j = 1, 9 do
			self:InitModelPlants(Plants[i][j].model, i, j)
		end
	end
	for i = 1, 5 do
		local r = math.random(3)
		self:InitModelGhouls(Ghouls[i].model, r, i)
	end
	frame:SetScript("OnUpdate", PlantsVsGhouls.FrameOnUpdate)
	PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\dirt_rise.ogg", "Master")
end

SlashCmdList["PlantsVsGhouls"] = function(msg)
	PlantsVsGhouls:SlashCommands(msg)
end
SLASH_PlantsVsGhouls1 = "/pvg"
SLASH_PlantsVsGhouls2 = "/plantsvsghouls"

function PlantsVsGhouls:SlashCommands(msg)
	if msg == "" then
		if mainframe:IsVisible() then
			mainframe:Hide()
			sodendcap:SetSize(72 * math.sqrt(2), 72 * math.sqrt(2))
			sodend:SetWidth(60)
			percentCompleted = 0
		else
			mainframe:Show()
			PlantsVsGhouls:InitAll()
		end
	end
end

function PlantsVsGhouls:ResizeFrame(frame)
	local Width = frame:GetWidth()
	local Height = frame:GetHeight()
	frame.resizeframeleft = CreateFrame("Frame", nil, frame)
	frame.resizeframeleft:SetPoint("BottomRight", frame, "BottomRight", 0, 0)
	frame.resizeframeleft:SetWidth(16)
	frame.resizeframeleft:SetHeight(16)
	frame.resizeframeleft:SetFrameLevel(frame:GetFrameLevel() + 7)
	frame.resizeframeleft:EnableMouse(true)
	if ScaleLocked then
		frame.resizeframeleft:Hide()
	else
		frame.resizeframeleft:Show()
	end
	frame.resizetextureleft = frame.resizeframeleft:CreateTexture(nil, "Artwork")
	frame.resizetextureleft:SetPoint("TopLeft", frame.resizeframeleft, "TopLeft", 0, 0)
	frame.resizetextureleft:SetWidth(16)
	frame.resizetextureleft:SetHeight(16)
	frame.resizetextureleft:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	frame:SetMaxResize(Width * 1.5, Height * 1.5)
	frame:SetMinResize(Width / 1.5, Height / 1.5)
	frame:SetResizable(true)
	frame.resizeframeleft:SetScript("OnEnter", function(self)
		frame.resizetextureleft:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	end)
	frame.resizeframeleft:SetScript("OnLeave", function(self)
		frame.resizetextureleft:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	end)
	frame.resizeframeleft:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" then
			frame:StartSizing("Right")
		end
		frame.resizetextureleft:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
	end)
	frame.resizeframeleft:SetScript("OnMouseUp", function(self, button)
		if button == "RightButton" then
			frame:SetWidth(Width)
			frame:SetHeight(Height)
		end
		if button == "MiddleButton" then
			ScaleLocked = true
			frame.resizetextureleft:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
		else
			local x, y = GetCursorPosition()
			local fx = self:GetLeft() * self:GetEffectiveScale()
			local fy = self:GetBottom() * self:GetEffectiveScale()
			if x >= fx and x <= (fx + self:GetWidth()) and y >= fy and y <= (fy + self:GetHeight()) then
				frame.resizetextureleft:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
			else
				frame.resizetextureleft:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
			end
			frame:StopMovingOrSizing()
		end
	end)
	frame.resizeframeright = CreateFrame("Frame", nil, frame)
	frame.resizeframeright:SetPoint("BottomLeft", frame, "BottomLeft", 0, 0)
	frame.resizeframeright:SetWidth(16)
	frame.resizeframeright:SetHeight(16)
	frame.resizeframeright:SetFrameLevel(frame:GetFrameLevel() + 7)
	frame.resizeframeright:EnableMouse(true)
	if ScaleLocked then
		frame.resizeframeright:Hide()
	else
		frame.resizeframeright:Show()
	end
	frame.resizetextureright = frame.resizeframeright:CreateTexture(nil, "Artwork")
	frame.resizetextureright:SetPoint("TopLeft", frame.resizeframeright, "TopLeft", 0, 0)
	frame.resizetextureright:SetWidth(16)
	frame.resizetextureright:SetHeight(16)
	frame.resizetextureright:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = frame.resizetextureright:GetTexCoord()
	frame.resizetextureright:SetTexCoord(URx, URy, LRx, LRy, ULx, ULy, LLx, LLy)
	frame.resizeframeright:SetScript("OnEnter", function(self)
		frame.resizetextureright:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	end)
	frame.resizeframeright:SetScript("OnLeave", function(self)
		frame.resizetextureright:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	end)
	frame.resizeframeright:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" then
			frame:StartSizing("Left")
		end
		frame.resizetextureright:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
	end)
	frame.resizeframeright:SetScript("OnMouseUp", function(self, button)
		if button == "RightButton" then
			frame:SetWidth(Width)
			frame:SetHeight(Height)
		end
		if button == "MiddleButton" then
			ScaleLocked = true
			frame.resizetextureright:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
		else
			local x, y = GetCursorPosition()
			local fx = self:GetLeft() * self:GetEffectiveScale()
			local fy = self:GetBottom() * self:GetEffectiveScale()
			if x >= fx and x <= (fx + self:GetWidth()) and y >= fy and y <= (fy + self:GetHeight()) then
				frame.resizetextureright:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
			else
				frame.resizetextureright:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
			end
			frame:StopMovingOrSizing()
		end
	end)
	frame.scrollframe = CreateFrame("ScrollFrame", nil, frame)
	frame.scrollframe:SetWidth(Width)
	frame.scrollframe:SetHeight(Height)
	frame.scrollframe:SetPoint("Topleft", frame, "Topleft", 0, 0)
	frame:SetScript("OnSizeChanged", function(self)
		local s = self:GetWidth() / Width
		frame.scrollframe:SetScale(s)
		local childrens = {self:GetChildren()}
		for _, child in ipairs(childrens) do
			if child ~= frame.resizeframeleft and child ~= frame.resizeframeright and child ~= sunmodel and child ~= modelslotx then
				child:SetScale(s)
			end
		end
		self:SetHeight(Height * s)
	end)
end