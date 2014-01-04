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
		[1] = {frame, model, x, y, type, degree},
		[2] = {frame, model, x, y, type, degree},
		[3] = {frame, model, x, y, type, degree},
		[4] = {frame, model, x, y, type, degree},
		[5] = {frame, model, x, y, type, degree},
		[6] = {frame, model, x, y, type, degree},
		[7] = {frame, model, x, y, type, degree},
		[8] = {frame, model, x, y, type, degree},
		[9] = {frame, model, x, y, type, degree}
	},
	[2] = {
		[1] = {frame, model, x, y, type, degree},
		[2] = {frame, model, x, y, type, degree},
		[3] = {frame, model, x, y, type, degree},
		[4] = {frame, model, x, y, type, degree},
		[5] = {frame, model, x, y, type, degree},
		[6] = {frame, model, x, y, type, degree},
		[7] = {frame, model, x, y, type, degree},
		[8] = {frame, model, x, y, type, degree},
		[9] = {frame, model, x, y, type, degree}
	},
	[3] = {
		[1] = {frame, model, x, y, type, degree},
		[2] = {frame, model, x, y, type, degree},
		[3] = {frame, model, x, y, type, degree},
		[4] = {frame, model, x, y, type, degree},
		[5] = {frame, model, x, y, type, degree},
		[6] = {frame, model, x, y, type, degree},
		[7] = {frame, model, x, y, type, degree},
		[8] = {frame, model, x, y, type, degree},
		[9] = {frame, model, x, y, type, degree}
	},
	[4] = {
		[1] = {frame, model, x, y, type, degree},
		[2] = {frame, model, x, y, type, degree},
		[3] = {frame, model, x, y, type, degree},
		[4] = {frame, model, x, y, type, degree},
		[5] = {frame, model, x, y, type, degree},
		[6] = {frame, model, x, y, type, degree},
		[7] = {frame, model, x, y, type, degree},
		[8] = {frame, model, x, y, type, degree},
		[9] = {frame, model, x, y, type, degree}
	},
	[5] = {
		[1] = {frame, model, x, y, type, degree},
		[2] = {frame, model, x, y, type, degree},
		[3] = {frame, model, x, y, type, degree},
		[4] = {frame, model, x, y, type, degree},
		[5] = {frame, model, x, y, type, degree},
		[6] = {frame, model, x, y, type, degree},
		[7] = {frame, model, x, y, type, degree},
		[8] = {frame, model, x, y, type, degree},
		[9] = {frame, model, x, y, type, degree}
	}
}

local Ghouls = {
	
}

local PlantModels = {
	[1] = "Creature\\LasherSunflower\\lasher_sunflower.m2"
}

local CurrentLine = nil
local CurrentRow = nil
local CurrentGrid = nil

local CurrentPlant = nil

local CurrentDegree = nil

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

local backdrop = {
	--edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
	edgeSize = 10,
	insets = {
		left = 11,
		right = 11,
		top = 11,
		bottom = 11
	}
}

local slot0 = CreateFrame("Frame", nil, frame)
slot0:SetPoint("TopLeft", map, "TopLeft", 25, - 25)
slot0:SetWidth(150)
slot0:SetHeight(75)
slot0:SetAlpha(1)
slot0:SetBackdrop(backdrop)

local modelslot0 = CreateFrame("PlayerModel", nil, frame)

function InitModelSlot0()
	modelslot0:SetModel("Spells\\Holybomb_missle.m2")
	modelslot0:SetAlpha(1)
	modelslot0:SetAllPoints(slot0)
end
InitModelSlot0()

local slot1 = CreateFrame("Frame", nil, frame)
slot1:SetPoint("Top", slot0, "Bottom", 0, - 25)
slot1:SetWidth(150)
slot1:SetHeight(75)
slot1:SetAlpha(1)
slot1:SetBackdrop(backdrop)

local modelslot1 = CreateFrame("PlayerModel", nil, frame)

function InitModelSlot1()
	modelslot1:SetModel("Creature\\LasherSunflower\\lasher_sunflower.m2")
	modelslot1:SetAlpha(1)
	modelslot1:SetCamera(0)
	modelslot1:SetAllPoints(slot1)
end
InitModelSlot1()

local cursortempframe = CreateFrame("Frame", nil, UIParent)
cursortempframe:SetFrameStrata("High")
cursortempframe:SetFrameLevel(0)
cursortempframe:SetAlpha(1)
cursortempframe:SetAllPoints(UIParent)

local cursortemp = CreateFrame("PlayerModel", nil, cursortempframe)

modelslot1:SetScript("OnMouseDown", function(self, button)
	DestroyMode = false
	PlantMode = not PlantMode
	if PlantMode then
		PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\seedlift.ogg", "Master")
	else
		DisableModes()
		PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\tap.ogg", "Master")
	end
	CurrentPlant = 1
	CreateCursorTemp()
	cursortemp:SetScript("OnUpdate", OnUpdate)
end)

local slot2 = CreateFrame("Frame", nil, frame)
slot2:SetPoint("Top", slot1, "Bottom", 0, 0)
slot2:SetWidth(150)
slot2:SetHeight(75)
slot2:SetAlpha(1)
slot2:SetBackdrop(backdrop)

local modelslot2 = CreateFrame("PlayerModel", nil, frame)

function InitModelSlot2()
	modelslot2:SetModel("World\\Generic\\goblin\\passivedoodads\\kezan\\items\\goblin_beachshovel_02.m2")
	modelslot2:SetAlpha(1)
	modelslot2:SetPosition(6.20, 0.03, 2.70)
	modelslot2:SetRotation(math.rad(128))
	modelslot2:SetAllPoints(slot2)
end
InitModelSlot2()

modelslot2:SetScript("OnMouseDown", function(self, button)
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

function CreateCursorTemp()
	if PlantMode then
		cursortemp:SetModel(PlantModels[CurrentPlant])
		cursortemp:SetAlpha(1)
		cursortemp:SetCustomCamera(1)
		cursortemp:SetWidth(200)
		cursortemp:SetHeight(200)
		CurrentDegree = math.random(45)
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

function CreateTemp(grid)
	if PlantMode and Plants[CurrentLine][CurrentRow].type == nil then
		temp:SetModel(PlantModels[CurrentPlant])
		temp:SetPoint("Center", grid, "TopLeft", grid.x, - grid.y)
		temp:SetAlpha(0.7)
		temp:SetCustomCamera(1)
		temp:SetWidth(200)
		temp:SetHeight(200)
		Plants[CurrentLine][CurrentRow].degree = CurrentDegree
		temp:SetRotation(math.rad(Plants[CurrentLine][CurrentRow].degree))
		SetModelTilt(temp, 55)
	end
end

function ClearTemp()
	temp:ClearModel()
end

function OnUpdate(self, elapsed)
	local x, y = GetCursorPosition()
	local scale = 1 / UIParent:GetEffectiveScale()
	if PlantMode then
		cursortemp:SetPoint("Center", UIParent, "BottomLeft", x * scale, y * scale)
	elseif DestroyMode then
		cursortemp:SetPoint("Center", UIParent, "BottomLeft", x * scale + (cursortemp:GetWidth() * 0.55), y * scale + (cursortemp:GetWidth() * 0.12))
	end
end

local ghoulframe = CreateFrame("Frame", nil, frame)
ghoulframe:SetFrameStrata("Medium")
ghoulframe:SetPoint("Right", Plants[1][1].frame, "Right", 900, 5)
ghoulframe:SetAlpha(1)
ghoulframe:SetWidth(200)
ghoulframe:SetHeight(200)

local ghoulmodel = CreateFrame("PlayerModel", nil, ghoulframe)
ghoulmodel:SetAllPoints(ghoulframe)

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
		Plants[i][j].frame:SetBackdrop(backdrop)
		Plants[i][j].frame.x = Plants[i][j].frame:GetWidth() / 2
		Plants[i][j].frame.y = Plants[i][j].frame:GetHeight() / 2
		Plants[i][j].model = CreateFrame("PlayerModel", nil, frame)
		Plants[i][j].frame:SetScript("OnEnter", function(self)
			OnEnter(self, i, j, Plants[i][j].model)
		end)
		Plants[i][j].frame:SetScript("OnLeave", function(self)
			OnLeave(Plants[i][j].model)
		end)
		Plants[i][j].frame:SetScript("OnMouseDown", function(self, button)
			OnMouseDown(self, button, Plants[i][j].model, ghoulmodel)
		end)
	end
end

function OnEnter(self, line, row, model)
	CurrentGrid = self
	CurrentLine = line
	CurrentRow = row
	if PlantMode and Plants[CurrentLine][CurrentRow].type == nil then
		CreateTemp(self)
	elseif DestroyMode then
		model:SetLight(1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1)
	end
end

function OnLeave(model)
	if PlantMode then
		temp:ClearModel()
	elseif DestroyMode then
		model:SetLight(1, 0, 0, 1, 0, 1, 0.7, 0.7, 0.7, 1, 0.8, 0.8, 0.64)
	end
end

function OnMouseDown(self, button, model, ghoul)
	if button == "LeftButton" then
		if PlantMode then
			CreatePlant(self, model, ghoul)
		elseif DestroyMode then
			DestroyPlant(model)
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

function CreatePlant(grid, model, ghoul)
	if PlantMode and Plants[CurrentLine][CurrentRow].type == nil then
		Plants[CurrentLine][CurrentRow].type = 1
		if GetDistance(grid, ghoul) < - 120 and GetDistance(grid, ghoul) > - 170 then
			ghoulmodel.next = CurrentRow
		end
		InitModel(model, CurrentLine, CurrentRow)
		DisableModes()
		cursortemp:SetScript("OnUpdate", nil)
		PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\plant.ogg", "Master")
	end
end

function InitModel(model, line, row)
	if Plants[line][row].type ~= nil then
		model:SetModel(PlantModels[CurrentPlant])
		model:SetPoint("Center", Plants[line][row].frame, "TopLeft", Plants[line][row].frame.x, - Plants[line][row].frame.y)
		model:SetAlpha(1)
		model:SetCustomCamera(1)
		model:SetWidth(200)
		model:SetHeight(200)
		model:SetRotation(math.rad(Plants[line][row].degree))
		SetModelTilt(model, 55)
	end
end

function DestroyPlant(model)
	if DestroyMode and Plants[CurrentLine][CurrentRow].type ~= nil then
		Plants[CurrentLine][CurrentRow].type = nil
		model:SetLight(1, 0, 0, 1, 0, 1, 0.7, 0.7, 0.7, 1, 0.8, 0.8, 0.64)
		model:ClearModel()
		DisableModes()
		PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\shovel.ogg", "Master")
	end
end

function SetModelColorFrozen(model)
	model:SetLight(1, 0, 0, 1, 0, 1, 0.3, 0.3, 1, 1, 0.3, 0.3, 1)
end

function GetNextPlant(model, x)
	for i = 1, x do
		if Plants[model.line][i].type ~= nil then
			model.next = i
		end
	end
end

function ChangeModelsAnimation(model, anim)
	if anim and anim > - 1 and anim < 802 then
		local elapsed = 0
		model:SetScript("OnUpdate", function(self, elaps)
			elapsed = elapsed + (elaps * 600)
			model:SetSequenceTime(anim, elapsed)
			if anim == 5 then
				ghoulframe:SetPoint("Right", Plants[1][1].frame, "Right", model.pos, 5)
				if GetDistance(Plants[1][9].frame, model) > - 170 and GetDistance(Plants[1][9].frame, model) < - 120 and Plants[1][9].type ~= nil then
					ChangeModelsAnimation(model, 61)
				elseif GetDistance(Plants[1][8].frame, model) > - 170 and GetDistance(Plants[1][8].frame, model) < - 120 and Plants[1][8].type ~= nil then
					ChangeModelsAnimation(model, 61)
				elseif GetDistance(Plants[1][7].frame, model) > - 170 and GetDistance(Plants[1][7].frame, model) < - 120 and Plants[1][7].type ~= nil then
					ChangeModelsAnimation(model, 61)
				elseif GetDistance(Plants[1][6].frame, model) > - 170 and GetDistance(Plants[1][6].frame, model) < - 120 and Plants[1][6].type ~= nil then
					ChangeModelsAnimation(model, 61)
				elseif GetDistance(Plants[1][5].frame, model) > - 170 and GetDistance(Plants[1][5].frame, model) < - 120 and Plants[1][5].type ~= nil then
					ChangeModelsAnimation(model, 61)
				elseif GetDistance(Plants[1][4].frame, model) > - 170 and GetDistance(Plants[1][4].frame, model) < - 120 and Plants[1][4].type ~= nil then
					ChangeModelsAnimation(model, 61)
				elseif GetDistance(Plants[1][3].frame, model) > - 170 and GetDistance(Plants[1][3].frame, model) < - 120 and Plants[1][3].type ~= nil then
					ChangeModelsAnimation(model, 61)
				elseif GetDistance(Plants[1][2].frame, model) > - 170 and GetDistance(Plants[1][2].frame, model) < - 120 and Plants[1][2].type ~= nil then
					ChangeModelsAnimation(model, 61)
				elseif GetDistance(Plants[1][1].frame, model) > - 170 and GetDistance(Plants[1][1].frame, model) < - 120 and Plants[1][1].type ~= nil then
					ChangeModelsAnimation(model, 61)
				end
				if model.pos > - 30 then
					model.pos = model.pos - 0.3
				else
					model:SetScript("OnUpdate", nil)
				end
			elseif anim == 61 then
				if Plants[model.line][model.next].type == nil then
					if GetDistance(Plants[1][2].frame, model) < - 170 then
						GetNextPlant(model, 1)
					elseif GetDistance(Plants[1][3].frame, model) < - 170 then
						GetNextPlant(model, 2)
					elseif GetDistance(Plants[1][4].frame, model) < - 170 then
						GetNextPlant(model, 3)
					elseif GetDistance(Plants[1][5].frame, model) < - 170 then
						GetNextPlant(model, 4)
					elseif GetDistance(Plants[1][6].frame, model) < - 170 then
						GetNextPlant(model, 5)
					elseif GetDistance(Plants[1][7].frame, model) < - 170 then
						GetNextPlant(model, 6)
					elseif GetDistance(Plants[1][8].frame, model) < - 170 then
						GetNextPlant(model, 7)
					elseif GetDistance(Plants[1][9].frame, model) < - 170 then
						GetNextPlant(model, 8)
					end
					ChangeModelsAnimation(model, 5)
				end
			end
		end)
	end
end

function InitModelGhoul(line)
	ghoulmodel.line = line
	ghoulmodel.next = 9
	ghoulmodel.pos = 900
	ghoulmodel:SetDisplayInfo(137)
	ghoulmodel:SetAlpha(1)
	ghoulmodel:SetCustomCamera(1)
	ghoulmodel:SetWidth(200)
	ghoulmodel:SetHeight(200)
	ghoulmodel:SetRotation(math.rad(0))
	local x, y, z = ghoulmodel:GetCameraPosition()
	local r = math.sqrt((x * x) + (y * y) + (z * z))
	SetOrientation(ghoulmodel, 4.5772, - 1.5346, - 0.9802)
	ChangeModelsAnimation(ghoulmodel, 5)
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
	ClearTemp()
	ClearCursorTemp()
	PlantMode = false
	DestroyMode = false
end

function InitAll()
	InitModelSlot0()
	InitModelSlot1()
	InitModelSlot2()
	for i = 1, 5 do
		for j = 1, 9 do
			InitModel(Plants[i][j].model, i, j)
		end
	end
	InitModelGhoul(1)
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