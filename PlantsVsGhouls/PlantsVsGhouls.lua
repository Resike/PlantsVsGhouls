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
		[1] = {type = nil, degree = 0},
		[2] = {type = nil, degree = 0},
		[3] = {type = nil, degree = 0},
		[4] = {type = nil, degree = 0},
		[5] = {type = nil, degree = 0},
		[6] = {type = nil, degree = 0},
		[7] = {type = nil, degree = 0},
		[8] = {type = nil, degree = 0},
		[9] = {type = nil, degree = 0}
	},
	[2] = {
		[1] = {type = nil, degree = 0},
		[2] = {type = nil, degree = 0},
		[3] = {type = nil, degree = 0},
		[4] = {type = nil, degree = 0},
		[5] = {type = nil, degree = 0},
		[6] = {type = nil, degree = 0},
		[7] = {type = nil, degree = 0},
		[8] = {type = nil, degree = 0},
		[9] = {type = nil, degree = 0}
	},
	[3] = {
		[1] = {type = nil, degree = 0},
		[2] = {type = nil, degree = 0},
		[3] = {type = nil, degree = 0},
		[4] = {type = nil, degree = 0},
		[5] = {type = nil, degree = 0},
		[6] = {type = nil, degree = 0},
		[7] = {type = nil, degree = 0},
		[8] = {type = nil, degree = 0},
		[9] = {type = nil, degree = 0}
	},
	[4] = {
		[1] = {type = nil, degree = 0},
		[2] = {type = nil, degree = 0},
		[3] = {type = nil, degree = 0},
		[4] = {type = nil, degree = 0},
		[5] = {type = nil, degree = 0},
		[6] = {type = nil, degree = 0},
		[7] = {type = nil, degree = 0},
		[8] = {type = nil, degree = 0},
		[9] = {type = nil, degree = 0}
	},
	[5] = {
		[1] = {type = nil, degree = 0},
		[2] = {type = nil, degree = 0},
		[3] = {type = nil, degree = 0},
		[4] = {type = nil, degree = 0},
		[5] = {type = nil, degree = 0},
		[6] = {type = nil, degree = 0},
		[7] = {type = nil, degree = 0},
		[8] = {type = nil, degree = 0},
		[9] = {type = nil, degree = 0}
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
		local x, y, z = temp:GetCameraPosition()
		local r = math.sqrt((x * x) + (y * y) + (z * z))
		SetModelTilt(temp, 55, x, y, z, r)
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

function CreateCursorTemp()
	if PlantMode then
		cursortemp:SetModel(PlantModels[CurrentPlant])
		cursortemp:SetAlpha(1)
		cursortemp:SetCustomCamera(1)
		cursortemp:SetWidth(200)
		cursortemp:SetHeight(200)
		CurrentDegree = math.random(45)
		cursortemp:SetRotation(math.rad(CurrentDegree))
		local x, y, z = cursortemp:GetCameraPosition()
		local r = math.sqrt((x * x) + (y * y) + (z * z))
		SetModelTilt(cursortemp, 55, x, y, z, r)
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

local ghoulframe = CreateFrame("Frame", nil, frame)
ghoulframe:SetFrameStrata("Medium")
ghoulframe:SetPoint("Right", grid11, "Right", 900, 5)
ghoulframe:SetAlpha(1)
ghoulframe:SetWidth(200)
ghoulframe:SetHeight(200)

local ghoulmodel = CreateFrame("PlayerModel", nil, ghoulframe)
ghoulmodel:SetAllPoints(ghoulframe)

local grid11 = CreateFrame("Frame", nil, frame)
grid11:SetPoint("TopLeft", map, "TopLeft", 256, - 81)
grid11:SetWidth(79)
grid11:SetHeight(95)
grid11:SetAlpha(1)
grid11:SetBackdrop(backdrop)
grid11.x = grid11:GetWidth() / 2
grid11.y = grid11:GetHeight() / 2

local model11 = CreateFrame("PlayerModel", nil, frame)

grid11:SetScript("OnEnter", function(self)
	CurrentLine = 1
	CurrentRow = 1
	CurrentGrid = self
	if PlantMode and Plants[CurrentLine][CurrentRow].type == nil then
		CreateTemp(self)
	elseif DestroyMode then
		model11:SetLight(1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1)
	end
end)

grid11:SetScript("OnLeave", function(self)
	if PlantMode then
		temp:ClearModel()
	elseif DestroyMode then
		model11:SetLight(1, 0, 0, 1, 0, 1, 0.69999998807907, 0.69999998807907, 0.69999998807907, 1, 0.80000001192093, 0.80000001192093, 0.63999998569489)
	end
end)

grid11:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		if PlantMode then
			CreatePlant11()
		elseif DestroyMode then
			DestroyPlant11()
		end
	else
		if PlantMode then
			DisableModes()
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\tap.ogg", "Master")
		elseif DestroyMode then
			DisableModes()
			model11:SetLight(1, 0, 0, 1, 0, 1, 0.69999998807907, 0.69999998807907, 0.69999998807907, 1, 0.80000001192093, 0.80000001192093, 0.63999998569489)
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\tap.ogg", "Master")
		end
	end
end)

function CreatePlant11()
	if PlantMode and Plants[CurrentLine][CurrentRow].type == nil then
		Plants[CurrentLine][CurrentRow].type = 1
		if GetDistance(grid11, ghoulmodel) < - 120 and GetDistance(grid11, ghoulmodel) > - 170 then
			ghoulmodel.next = 1
		end
		InitModel11()
		DisableModes()
		cursortemp:SetScript("OnUpdate", nil)
		PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\plant.ogg", "Master")
	end
end

function DestroyPlant11()
	if DestroyMode and Plants[CurrentLine][CurrentRow].type ~= nil then
		Plants[CurrentLine][CurrentRow].type = nil
		model11:SetLight(1, 0, 0, 1, 0, 1, 0.69999998807907, 0.69999998807907, 0.69999998807907, 1, 0.80000001192093, 0.80000001192093, 0.63999998569489)
		model11:ClearModel()
		DisableModes()
		PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\shovel.ogg", "Master")
	end
end

function InitModel11()
	if Plants[1][1].type ~= nil then
		model11:SetModel(PlantModels[CurrentPlant])
		model11:SetPoint("Center", grid11, "TopLeft", grid11.x, - grid11.y)
		model11:SetAlpha(1)
		model11:SetCustomCamera(1)
		model11:SetWidth(200)
		model11:SetHeight(200)
		model11:SetRotation(math.rad(Plants[1][1].degree))
		local x, y, z = model11:GetCameraPosition()
		local r = math.sqrt((x * x) + (y * y) + (z * z))
		SetModelTilt(model11, 55, x, y, z, r)
	end
end

local grid12 = CreateFrame("Frame", nil, frame)
grid12:SetPoint("BottomLeft", grid11, "BottomRight", 0, 0)
grid12:SetWidth(79)
grid12:SetHeight(100)
grid12:SetAlpha(1)
grid12:SetBackdrop(backdrop)
grid12.x = grid12:GetWidth() / 2
grid12.y = grid12:GetHeight() / 2

local model12 = CreateFrame("PlayerModel", nil, frame)

grid12:SetScript("OnEnter", function(self)
	CurrentLine = 1
	CurrentRow = 2
	CurrentGrid = self
	if PlantMode and Plants[CurrentLine][CurrentRow].type == nil then
		CreateTemp(self)
	elseif DestroyMode then
		model12:SetLight(1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1)
	end
end)

grid12:SetScript("OnLeave", function(self)
	if PlantMode then
		temp:ClearModel()
	elseif DestroyMode then
		model12:SetLight(1, 0, 0, 1, 0, 1, 0.69999998807907, 0.69999998807907, 0.69999998807907, 1, 0.80000001192093, 0.80000001192093, 0.63999998569489)
	end
end)

grid12:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		if PlantMode then
			CreatePlant12()
		elseif DestroyMode then
			DestroyPlant12()
		end
	else
		if PlantMode then
			DisableModes()
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\tap.ogg", "Master")
		elseif DestroyMode then
			DisableModes()
			model12:SetLight(1, 0, 0, 1, 0, 1, 0.69999998807907, 0.69999998807907, 0.69999998807907, 1, 0.80000001192093, 0.80000001192093, 0.63999998569489)
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\tap.ogg", "Master")
		end
	end
end)

function CreatePlant12()
	if PlantMode and Plants[CurrentLine][CurrentRow].type == nil then
		Plants[CurrentLine][CurrentRow].type = 1
		if GetDistance(grid12, ghoulmodel) < - 120 and GetDistance(grid12, ghoulmodel) > - 170 then
			ghoulmodel.next = 2
		end
		InitModel12()
		DisableModes()
		cursortemp:SetScript("OnUpdate", nil)
		PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\plant.ogg", "Master")
	end
end

function DestroyPlant12()
	if DestroyMode and Plants[CurrentLine][CurrentRow].type ~= nil then
		Plants[CurrentLine][CurrentRow].type = nil
		model12:SetLight(1, 0, 0, 1, 0, 1, 0.69999998807907, 0.69999998807907, 0.69999998807907, 1, 0.80000001192093, 0.80000001192093, 0.63999998569489)
		model12:ClearModel()
		DisableModes()
		PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\shovel.ogg", "Master")
	end
end

function InitModel12()
	if Plants[1][2].type ~= nil then
		model12:SetModel(PlantModels[CurrentPlant])
		model12:SetPoint("Center", grid12, "TopLeft", grid12.x, - grid12.y)
		model12:SetAlpha(1)
		model12:SetCustomCamera(1)
		model12:SetWidth(200)
		model12:SetHeight(200)
		model12:SetRotation(math.rad(Plants[1][2].degree))
		local x, y, z = model12:GetCameraPosition()
		local r = math.sqrt((x * x) + (y * y) + (z * z))
		SetModelTilt(model12, 55, x, y, z, r)
	end
end

local grid13 = CreateFrame("Frame", nil, frame)
grid13:SetPoint("BottomLeft", grid12, "BottomRight", 0, 0)
grid13:SetWidth(79)
grid13:SetHeight(105)
grid13:SetAlpha(1)
grid13:SetBackdrop(backdrop)
grid13.x = grid13:GetWidth() / 2
grid13.y = grid13:GetHeight() / 2

local model13 = CreateFrame("PlayerModel", nil, frame)

grid13:SetScript("OnEnter", function(self)
	CurrentLine = 1
	CurrentRow = 3
	CurrentGrid = self
	if PlantMode and Plants[CurrentLine][CurrentRow].type == nil then
		CreateTemp(self)
	elseif DestroyMode then
		model13:SetLight(1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1)
	end
end)

grid13:SetScript("OnLeave", function(self)
	if PlantMode then
		temp:ClearModel()
	elseif DestroyMode then
		model13:SetLight(1, 0, 0, 1, 0, 1, 0.69999998807907, 0.69999998807907, 0.69999998807907, 1, 0.80000001192093, 0.80000001192093, 0.63999998569489)
	end
end)

grid13:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		if PlantMode then
			CreatePlant13()
		elseif DestroyMode then
			DestroyPlant13()
		end
	else
		if PlantMode then
			DisableModes()
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\tap.ogg", "Master")
		elseif DestroyMode then
			DisableModes()
			model13:SetLight(1, 0, 0, 1, 0, 1, 0.69999998807907, 0.69999998807907, 0.69999998807907, 1, 0.80000001192093, 0.80000001192093, 0.63999998569489)
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\tap.ogg", "Master")
		end
	end
end)

function CreatePlant13()
	if PlantMode and Plants[CurrentLine][CurrentRow].type == nil then
		Plants[CurrentLine][CurrentRow].type = 1
		InitModel13()
		if GetDistance(grid13, ghoulmodel) < - 120 and GetDistance(grid13, ghoulmodel) > - 170 then
			ghoulmodel.next = 3
		end
		DisableModes()
		cursortemp:SetScript("OnUpdate", nil)
		PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\plant.ogg", "Master")
	end
end

function DestroyPlant13()
	if DestroyMode and Plants[CurrentLine][CurrentRow].type ~= nil then
		Plants[CurrentLine][CurrentRow].type = nil
		model13:SetLight(1, 0, 0, 1, 0, 1, 0.69999998807907, 0.69999998807907, 0.69999998807907, 1, 0.80000001192093, 0.80000001192093, 0.63999998569489)
		model13:ClearModel()
		DisableModes()
		PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\shovel.ogg", "Master")
	end
end

function InitModel13()
	if Plants[1][3].type ~= nil then
		model13:SetModel(PlantModels[CurrentPlant])
		model13:SetPoint("Center", grid13, "TopLeft", grid13.x, - grid13.y)
		model13:SetAlpha(1)
		model13:SetCustomCamera(1)
		model13:SetWidth(200)
		model13:SetHeight(200)
		model13:SetRotation(math.rad(Plants[1][3].degree))
		local x, y, z = model13:GetCameraPosition()
		local r = math.sqrt((x * x) + (y * y) + (z * z))
		SetModelTilt(model13, 55, x, y, z, r)
	end
end

local grid14 = CreateFrame("Frame", nil, frame)
grid14:SetPoint("BottomLeft", grid13, "BottomRight", 0, 0)
grid14:SetWidth(83)
grid14:SetHeight(110)
grid14:SetAlpha(1)
grid14:SetBackdrop(backdrop)

local grid15 = CreateFrame("Frame", nil, frame)
grid15:SetPoint("BottomLeft", grid14, "BottomRight", 0, 0)
grid15:SetWidth(79)
grid15:SetHeight(110)
grid15:SetAlpha(1)
grid15:SetBackdrop(backdrop)

local grid16 = CreateFrame("Frame", nil, frame)
grid16:SetPoint("BottomLeft", grid15, "BottomRight", 0, 0)
grid16:SetWidth(83)
grid16:SetHeight(110)
grid16:SetAlpha(1)
grid16:SetBackdrop(backdrop)

local grid17 = CreateFrame("Frame", nil, frame)
grid17:SetPoint("BottomLeft", grid16, "BottomRight", 0, 0)
grid17:SetWidth(79)
grid17:SetHeight(105)
grid17:SetAlpha(1)
grid17:SetBackdrop(backdrop)

local grid18 = CreateFrame("Frame", nil, frame)
grid18:SetPoint("BottomLeft", grid17, "BottomRight", 0, 0)
grid18:SetWidth(79)
grid18:SetHeight(100)
grid18:SetAlpha(1)
grid18:SetBackdrop(backdrop)

local grid19 = CreateFrame("Frame", nil, frame)
grid19:SetPoint("BottomLeft", grid18, "BottomRight", 0, 0)
grid19:SetWidth(79)
grid19:SetHeight(95)
grid19:SetAlpha(1)
grid19:SetBackdrop(backdrop)

function SetModelColorFrozen(model)
	model:SetLight(1, 0, 0, 1, 0, 1, 0.3, 0.3, 1, 1, 0.3, 0.3, 1)
end

function ChangeModelsAnimation(model, anim)
	if anim and anim > - 1 and anim < 802 then
		local elapsed = 0
		model:SetScript("OnUpdate", function(self, elaps)
			elapsed = elapsed + (elaps * 600)
			model:SetSequenceTime(anim, elapsed)
			if anim == 5 then
				ghoulframe:SetPoint("Right", grid11, "Right", model.pos, 5)
				if (GetDistance(grid13, model) < - 120 and GetDistance(grid13, model) > - 170 and Plants[1][3].type ~= nil) then
					ChangeModelsAnimation(model, 61)
				elseif (GetDistance(grid12, model) < - 120 and GetDistance(grid12, model) > - 170 and Plants[1][2].type ~= nil) then
					ChangeModelsAnimation(model, 61)
				elseif (GetDistance(grid11, model) < - 120 and GetDistance(grid11, model) > - 170 and Plants[1][1].type ~= nil) then
					ChangeModelsAnimation(model, 61)
				end
				if model.pos > - 30 then
					model.pos = model.pos - 0.3
				else
					model:SetScript("OnUpdate", nil)
				end
			elseif anim == 61 then
				if Plants[model.line][model.next].type == nil then
					ChangeModelsAnimation(model, 5)
					--[[if GetDistance(grid19, model) > - 170 then
						model.next = 8
					elseif GetDistance(grid18, model) > - 170 then
						model.next = 7
					elseif GetDistance(grid17, model) > - 170 then
						model.next = 6
					elseif GetDistance(grid16, model) > - 170 then
						model.next = 5
					elseif GetDistance(grid15, model) > - 170 then
						model.next = 4
					elseif GetDistance(grid14, model) > - 170 then
						model.next = 3
					else]]
					if GetDistance(grid13, model) > - 170 then
						model.next = 2
					elseif GetDistance(grid12, model) > - 170 then
						model.next = 1
					elseif GetDistance(grid11, model) > - 170 then
						model.next = 0
					end
				end
			end
		end)
	end
end

function InitModelGhoul(line)
	ghoulmodel.line = line
	ghoulmodel:SetDisplayInfo(137)
	ghoulmodel.pos = 900
	ghoulmodel.next = 3
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

function SetModelTilt(model, tiltdegree, x, y, z, r)
	if model:HasCustomCamera() then
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
	InitModel11()
	InitModel12()
	InitModel13()
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