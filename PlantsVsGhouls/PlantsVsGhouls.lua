SlashCmdList["PlantsVsGhouls"] = function(msg)
	PlantsVsGhouls_SlashCommands(msg)
end
SLASH_PlantsVsGhouls1 = "/pvg"
SLASH_PlantsVsGhouls2 = "/plantsvsghouls"

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
	[1] = {model = "Creature\\LasherSunflower\\lasher_sunflower.m2", health = 100, cooldown = 1.5}
}

local Ghouls = {
	[1] = {frame, model},
	[2] = {frame, model},
	[3] = {frame, model},
	[4] = {frame, model},
	[5] = {frame, model}
}

local GhoulTypes = {
	-- Vanilla Ghoul
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

local frame = CreateFrame("Frame", nil, mainframe)
frame:SetPoint("Center", 0, 0)
frame:SetWidth(1400)
frame:SetHeight(600)
frame:SetAlpha(1)

frame:SetScript("OnMouseDown", function(self, button)
	if button == "RightButton" then
		if PlantMode then
			PlantMode = false
			ClearTemp()
			ClearCursorTemp()
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\tap.ogg", "Master")
		elseif DestroyMode then
			DestroyMode = false
			ClearCursorTemp()
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\tap.ogg", "Master")
		end
	end
end)

local map = frame:CreateTexture(nil, "Background")
map:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\background1.tga")
map:SetWidth(1400)
map:SetHeight(600)
map:SetAlpha(1)
map:SetBlendMode("Disable")
map:SetDrawLayer("Background", 0)
map:SetAllPoints(frame)

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

function InitSunModel()
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

function CreateCursorTemp()
	if PlantMode then
		cursortemp:SetModel(PlantTypes[CurrentPlant].model)
		cursortemp:SetAlpha(1)
		cursortemp:SetCustomCamera(1)
		CurrentDegree = math.random(0, 45)
		CurrentSize = 200 + math.random(0, 30)
		cursortemp:SetWidth(CurrentSize)
		cursortemp:SetHeight(CurrentSize)
		cursortemp:SetRotation(math.rad(CurrentDegree))
		SetModelTilt(cursortemp, 55)
	elseif DestroyMode then
		cursortemp:SetModel("World\\Generic\\goblin\\passivedoodads\\kezan\\items\\goblin_beachshovel_02.m2")
		cursortemp:SetAlpha(1)
		cursortemp:SetWidth(125)
		cursortemp:SetHeight(125)
		cursortemp:SetPosition(6.20, 0.03, 2.70)
		cursortemp:SetRotation(math.rad(128))
	end
end

function ClearCursorTemp()
	cursortemp:ClearModel()
end

local temp = CreateFrame("PlayerModel", nil, frame)

function CreateTemp(frame, model)
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
		SetModelTilt(temp, 55)
	end
end

function ClearTemp()
	temp:ClearModel()
end

for i = 1, 5 do
	Slots[i].frame = CreateFrame("Frame", nil, frame)
	if i == 1 then
		Slots[i].frame:SetPoint("Top", sun, "Bottom", 0, 0)
	else
		Slots[i].frame:SetPoint("Top", Slots[i - 1].frame, "Bottom", 0, 0)
	end
	Slots[i].frame:SetWidth(150)
	Slots[i].frame:SetHeight(75)
	Slots[i].frame:SetAlpha(1)
	Slots[i].frame:SetBackdrop(SlotBackdrop)
	Slots[i].frame:SetBackdropColor(0.5, 0.5, 0.5, 0.5)
	Slots[i].model = CreateFrame("PlayerModel", nil, frame)
	if i == 1 then
		Slots[i].model:SetPoint("Top", sun, "Bottom", 0, 0)
	else
		Slots[i].model:SetPoint("Top", Slots[i - 1].frame, "Bottom", 0, 0)
	end
	Slots[i].cooldown = CreateFrame("Cooldown", nil, Slots[i].frame)
	Slots[i].cooldown:SetAllPoints(Slots[i].frame)
	Slots[i].model:SetScript("OnMouseDown", function(self, button)
		SlotOnMouseDown(button, Slots[i].model, Slots[i].cooldown)
	end)
end

local slotx = CreateFrame("Frame", nil, frame)
slotx:SetPoint("Top", Slots[5].frame, "Bottom", 0, 0)
slotx:SetWidth(150)
slotx:SetHeight(75)
slotx:SetAlpha(1)
slotx:SetBackdrop(SlotBackdrop)
slotx:SetBackdropColor(0.5, 0.5, 0.5, 0.5)

local modelslotx = CreateFrame("PlayerModel", nil, frame)

function InitModelSlotX()
	modelslotx:SetModel("World\\Generic\\goblin\\passivedoodads\\kezan\\items\\goblin_beachshovel_02.m2")
	modelslotx:SetAlpha(1)
	modelslotx:SetPosition(6.20, 0.03, 2.70)
	modelslotx:SetRotation(math.rad(128))
	modelslotx:SetAllPoints(slotx)
end
InitModelSlotX()

modelslotx:SetScript("OnMouseDown", function(self, button)
	PlantMode = false
	DestroyMode = not DestroyMode
	if DestroyMode then
		--PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\shovel.ogg", "Master")
	else
		DisableModes()
		PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\tap.ogg", "Master")
	end
	CreateCursorTemp()
	cursortemp:SetScript("OnUpdate", OnUpdate)
end)

function OnUpdate(self, elapsed)
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
			Plants[i][j].frame:SetPoint("TopLeft", map, "TopLeft", 256, - 81)
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
		Plants[i][j].frame.y = Plants[i][j].frame:GetHeight() / 2
		Plants[i][j].model = CreateFrame("PlayerModel", nil, Plants[i][j].frame)
		Plants[i][j].frame:SetScript("OnEnter", function(self)
			OnEnter(self, i, j, Plants[i][j].model)
		end)
		Plants[i][j].frame:SetScript("OnLeave", function(self)
			OnLeave(Plants[i][j].model)
		end)
		Plants[i][j].frame:SetScript("OnMouseDown", function(self, button)
			OnMouseDown(button, Plants[i][j].model)
		end)
	end
end

for i = 1, 5 do
	Ghouls[i].frame = CreateFrame("Frame", nil, frame)
	Ghouls[i].frame:SetFrameStrata("High")
	Ghouls[i].frame:SetPoint("Right", Plants[i][1].frame, "Right", 900, 5)
	Ghouls[i].frame:SetAlpha(1)
	Ghouls[i].frame:SetWidth(200)
	Ghouls[i].frame:SetHeight(200)
	Ghouls[i].model = CreateFrame("PlayerModel", nil, Ghouls[i].frame)
	Ghouls[i].model:SetAllPoints(Ghouls[i].frame)
end

function SlotOnMouseDown(button, model, cooldown)
	if not cooldown.start or GetTime() > (cooldown.start + PlantTypes[model.type].cooldown) then
		DestroyMode = false
		PlantMode = not PlantMode
		if PlantMode then
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\seedlift.ogg", "Master")
		else
			DisableModes()
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\tap.ogg", "Master")
		end
		CurrentPlant = model.type
		CurrentSlot = cooldown
		CreateCursorTemp()
		cursortemp:SetScript("OnUpdate", OnUpdate)
	else
		PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\buzzer.ogg", "Master")
	end
end

function InitModelSlots(model, type)
	model:SetModel(PlantTypes[type].model)
	model.type = type
	model:SetWidth(149)
	model:SetHeight(74)
	model:SetAlpha(1)
	model:SetCamera(0)
end
for i = 1, 5 do
	InitModelSlots(Slots[i].model, 1)
end

function OnEnter(self, line, row, model)
	CurrentGrid = self
	CurrentLine = line
	CurrentRow = row
	if PlantMode and Plants[CurrentLine][CurrentRow].model.type == nil then
		CreateTemp(self, model)
	elseif DestroyMode then
		model:SetLight(1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1)
	end
end

function OnLeave(model)
	CurrentGrid = nil
	CurrentLine = nil
	CurrentRow = nil
	if PlantMode then
		temp:ClearModel()
	elseif DestroyMode then
		model:SetLight(1, 0, 0, 1, 0, 1, 0.7, 0.7, 0.7, 1, 0.8, 0.8, 0.64)
	end
end

function OnMouseDown(button, model)
	if button == "LeftButton" then
		if PlantMode then
			CreatePlant(model)
		elseif DestroyMode then
			DestroyPlant(model, CurrentLine, CurrentRow)
		end
	else
		if PlantMode then
			DisableModes()
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\tap.ogg", "Master")
		elseif DestroyMode then
			DisableModes()
			model:SetLight(1, 0, 0, 1, 0, 1, 0.7, 0.7, 0.7, 1, 0.8, 0.8, 0.64)
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\tap.ogg", "Master")
		end
	end
end

function CreatePlant(model)
	if PlantMode and Plants[CurrentLine][CurrentRow].model.type == nil then
		Plants[CurrentLine][CurrentRow].model.time = GetTime()
		Plants[CurrentLine][CurrentRow].model.type = CurrentPlant
		Plants[CurrentLine][CurrentRow].model.health = PlantTypes[CurrentPlant].health
		CurrentSlot:SetCooldown(GetTime(), PlantTypes[CurrentPlant].cooldown)
		CurrentSlot.start = GetTime()
		InitModelPlants(model, CurrentLine, CurrentRow)
		DisableModes()
		cursortemp:SetScript("OnUpdate", nil)
		PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\plant.ogg", "Master")
	end
end

function InitModelPlants(model, line, row)
	if Plants[line][row].model.type ~= nil then
		model:SetModel(PlantTypes[CurrentPlant].model)
		model:SetPoint("Center", Plants[line][row].frame, "TopLeft", Plants[line][row].frame.x, - Plants[line][row].frame.y)
		model:SetAlpha(1)
		model:SetCustomCamera(1)
		model:SetWidth(Plants[line][row].model.size)
		model:SetHeight(Plants[line][row].model.size)
		model:SetRotation(math.rad(Plants[line][row].model.degree))
		SetModelTilt(model, 55)
	end
end

function DestroyPlant(model, line, row, kill)
	if Plants[line][row].model.type ~= nil then
		if not kill then
			Plants[line][row].model.type = nil
			Plants[line][row].model.health = nil
		end
		model:SetLight(1, 0, 0, 1, 0, 1, 0.7, 0.7, 0.7, 1, 0.8, 0.8, 0.64)
		model:ClearModel()
		if not kill then
			DisableModes()
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\shovel.ogg", "Master")
		end
	end
end

function SetModelColor(model, color)
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

function GetNextPlant(model, maxrow)
	if not model then
		return
	end
	for i = 1, maxrow do
		if Plants[model.line][i].model.type ~= nil then
			model.next = i
		end
	end
end

function ChangeModelsAnimation(model, anim)
	if anim and anim > - 1 and anim < 802 then
		local elapsed = 0
		local time = 0
		model:SetScript("OnUpdate", function(self, elaps)
			elapsed = elapsed + (elaps * 600)
			model:SetSequenceTime(anim, elapsed)
			if anim == 5 then
				Ghouls[model.line].frame:SetPoint("Right", Plants[model.line][1].frame, "Right", model.pos, 5)
				if GetDistance(Plants[model.line][9].frame, model) > model.startpos and GetDistance(Plants[model.line][9].frame, model) < model.endpos and Plants[model.line][9].model.type ~= nil then
					ChangeModelsAnimation(model, 61)
				elseif GetDistance(Plants[model.line][8].frame, model) > model.startpos and GetDistance(Plants[model.line][8].frame, model) < model.endpos and Plants[model.line][8].model.type ~= nil then
					ChangeModelsAnimation(model, 61)
				elseif GetDistance(Plants[model.line][7].frame, model) > model.startpos and GetDistance(Plants[model.line][7].frame, model) < model.endpos and Plants[model.line][7].model.type ~= nil then
					ChangeModelsAnimation(model, 61)
				elseif GetDistance(Plants[model.line][6].frame, model) > model.startpos and GetDistance(Plants[model.line][6].frame, model) < model.endpos and Plants[model.line][6].model.type ~= nil then
					ChangeModelsAnimation(model, 61)
				elseif GetDistance(Plants[model.line][5].frame, model) > model.startpos and GetDistance(Plants[model.line][5].frame, model) < model.endpos and Plants[model.line][5].model.type ~= nil then
					ChangeModelsAnimation(model, 61)
				elseif GetDistance(Plants[model.line][4].frame, model) > model.startpos and GetDistance(Plants[model.line][4].frame, model) < model.endpos and Plants[model.line][4].model.type ~= nil then
					ChangeModelsAnimation(model, 61)
				elseif GetDistance(Plants[model.line][3].frame, model) > model.startpos and GetDistance(Plants[model.line][3].frame, model) < model.endpos and Plants[model.line][3].model.type ~= nil then
					ChangeModelsAnimation(model, 61)
				elseif GetDistance(Plants[model.line][2].frame, model) > model.startpos and GetDistance(Plants[model.line][2].frame, model) < model.endpos and Plants[model.line][2].model.type ~= nil then
					ChangeModelsAnimation(model, 61)
				elseif GetDistance(Plants[model.line][1].frame, model) > model.startpos and GetDistance(Plants[model.line][1].frame, model) < model.endpos and Plants[model.line][1].model.type ~= nil then
					ChangeModelsAnimation(model, 61)
				end
				if model.pos > model.stoppos then
					model.pos = model.pos - model.speed
				else
					model:SetScript("OnUpdate", nil)
				end
			elseif anim == 61 then
				time = time + (elaps * 1000)
				if time > 800 and Plants[model.line][model.next].model.health and Plants[model.line][model.next].model.health > 0 then
					if not DestroyMode or (DestroyMode and (CurrentLine ~= model.line or CurrentRow ~= model.next)) then
						SetModelColor(Plants[model.line][model.next].model, "Red")
					elseif DestroyMode and CurrentLine == model.line and CurrentRow == model.next then
						SetModelColor(Plants[model.line][model.next].model, "RedGlow")
					end
				else
					if not DestroyMode or (DestroyMode and (CurrentLine ~= model.line or CurrentRow ~= model.next)) then
						SetModelColor(Plants[model.line][model.next].model)
					elseif DestroyMode and CurrentLine == model.line and CurrentRow == model.next then
						SetModelColor(Plants[model.line][model.next].model, "BaseGlow")
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
					DestroyPlant(Plants[model.line][model.next].model, model.line, model.next, true)
				end
				if Plants[model.line][model.next].model.type == nil then
					if GetDistance(Plants[model.line][2].frame, model) < model.startpos then
						GetNextPlant(model, 1)
					elseif GetDistance(Plants[model.line][3].frame, model) < model.startpos then
						GetNextPlant(model, 2)
					elseif GetDistance(Plants[model.line][4].frame, model) < model.startpos then
						GetNextPlant(model, 3)
					elseif GetDistance(Plants[model.line][5].frame, model) < model.startpos then
						GetNextPlant(model, 4)
					elseif GetDistance(Plants[model.line][6].frame, model) < model.startpos then
						GetNextPlant(model, 5)
					elseif GetDistance(Plants[model.line][7].frame, model) < model.startpos then
						GetNextPlant(model, 6)
					elseif GetDistance(Plants[model.line][8].frame, model) < model.startpos then
						GetNextPlant(model, 7)
					elseif GetDistance(Plants[model.line][9].frame, model) < model.startpos then
						GetNextPlant(model, 8)
					end
					ChangeModelsAnimation(model, 5)
				end
			end
		end)
	end
end

function InitModelGhouls(model, type, createdline)
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
	SetOrientation(model, model.distance, model.yaw, model.pitch)
	ChangeModelsAnimation(model, 5)
end

function GetDistance(obj1, obj2)
	return obj2:GetLeft() - (obj1:GetLeft() + obj1:GetWidth())
end

function GetBaseCameraTarget(model)
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

function SetOrientation(model, distance, yaw, pitch)
	if model:HasCustomCamera() then
		local x = distance * math.cos(yaw) * math.cos(pitch)
		local y = distance * math.sin(- yaw) * math.cos(pitch)
		local z = (distance * math.sin(- pitch))
		model:SetCameraPosition(x, y, z)
	end
end

function SetModelTilt(model, tiltdegree)
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
	local x, y, z = GetBaseCameraTarget(model)
	if y and z then
		model:SetCameraTarget(0, y, z)
	end
end

function DisableModes()
	ClearCursorTemp()
	ClearTemp()
	PlantMode = false
	DestroyMode = false
end

function InitAll()
	InitSunModel()
	for i = 1, 5 do
		InitModelSlots(Slots[i].model, 1)
	end
	InitModelSlotX()
	for i = 1, 5 do
		for j = 1, 9 do
			InitModelPlants(Plants[i][j].model, i, j)
		end
	end
	for i = 1, 5 do
		local r = math.random(3)
		InitModelGhouls(Ghouls[i].model, r, i)
	end
end

function PlantsVsGhouls_SlashCommands(msg)
	if msg == "" then
		if mainframe:IsVisible() then
			mainframe:Hide()
		else
			mainframe:Show()
			InitAll()
		end
	end
end