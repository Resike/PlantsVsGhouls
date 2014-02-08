local _, ns = ...

local PlantsVsGhouls = { }
ns.PlantsVsGhouls = PlantsVsGhouls

local ipairs = ipairs
local math = math
local print = print
local UIParent = UIParent

local CreateFontString = CreateFontString
local CreateFrame = CreateFrame
local CreateTexture = CreateTexture
local GetCursorPosition = GetCursorPosition
local GetObjectType = GetObjectType
local GetTime = GetTime
local IsMouseButtonDown = IsMouseButtonDown
local PlaySoundFile = PlaySoundFile
local UnitName = UnitName

local BaseScale = 0.73142856359482
local UIParentScale = 1
local WindowScale = 1

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
	[1] = {model = {[1] = 137, [2] = 414, [3] = 519, [4] = 547}, distance = 4.5772 / BaseScale, yaw = - 1.5346, pitch = - 0.9802, startpos = - 150, endpos = - 100, stoppos = - 20, speed = 0.3, damage = 34, health = 100},
	-- Burning Crusade Ghoul (938)
	[2] = {model = {[1] = 24992, [2] = 24993, [3] = 24994, [4] = 24995}, distance = 5.5772 / BaseScale, yaw = - 1.5346, pitch = - 0.9802, startpos = - 150, endpos = - 100, stoppos = - 20, speed = 0.4, damage = 41, health = 150},
	-- Burning Crusade Ghoul Spiked (939)
	[3] = {model = {[1] = 28292, [2] = 30656}, distance = 5.5772 / BaseScale, yaw = - 1.5346, pitch = - 0.9802, startpos = - 150, endpos = - 100, stoppos = - 20, speed = 0.4, damage = 45, health = 175}
}

local Slots = {
	[1] = {frame, model, cooldown},
	[2] = {frame, model, cooldown},
	[3] = {frame, model, cooldown},
	[4] = {frame, model, cooldown},
	[5] = {frame, model, cooldown}
}

local Sun = {
	-- (658)
	[1] = {frame, model},
	[2] = {frame, model},
	[3] = {frame, model},
	[4] = {frame, model},
	[5] = {frame, model}
}

local Debug = false

if UnitName("player") == "Resike" then
	Debug = true
end

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

local GameStarted = false

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

local mainframe = CreateFrame("Frame", nil, UIParent)
mainframe:SetFrameStrata("High")
mainframe:SetPoint("Center", 0, 0)
mainframe:SetWidth(1100)
mainframe:SetHeight(700)
mainframe:SetAlpha(1)
mainframe:SetMovable(true)
mainframe:Hide()

--mainframe:RegisterEvent("ADDON_LOADED")
--mainframe:RegisterEvent("PLAYER_ENTERING_WORLD")
mainframe:RegisterEvent("VARIABLES_LOADED")

function PlantsVsGhouls:OnEvent(event, ...)
	if event == "VARIABLES_LOADED" then
		UIParentScale = UIParent:GetScale()
		for i = 1, #GhoulTypes do
			--GhoulTypes[i].distance = GhoulTypes[i].distance * UIParentScale
		end
	end
end

mainframe:SetScript("OnEvent", PlantsVsGhouls.OnEvent)

local skyframe = CreateFrame("Frame", nil, mainframe)
skyframe:SetFrameStrata("Medium")
skyframe:SetWidth(1100)
skyframe:SetHeight(700)
skyframe:SetAlpha(1)
skyframe:SetPoint("Center", mainframe, "Center", 0, 0)

local sky = CreateFrame("PlayerModel", nil, skyframe)

function PlantsVsGhouls:InitModelSky()
	sky:SetModel("Environments\\Stars\\Maelstrom_Sky03_Stormbreak.m2")
	--sky:SetModel("Environments\\Stars\\Lostislegloomyskybox.m2")
	sky:SetWidth(1099)
	sky:SetHeight(699)
	sky:SetAlpha(1)
	sky:SetPoint("TopLeft", skyframe, "TopLeft", 0, 0)
end

local house = mainframe:CreateTexture(nil, "Background")
house:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\House.tga")
house:SetWidth(864)
house:SetHeight(420)
house:SetAlpha(0.99)
house:SetBlendMode("Disable")
house:SetDrawLayer("Background", - 1)
house:SetPoint("BottomLeft", mainframe, "BottomLeft", 0, 0)

local treeframe = CreateFrame("Frame", nil, mainframe)
treeframe:SetFrameStrata("High")
treeframe:SetWidth(476)
treeframe:SetHeight(700)
treeframe:SetAlpha(1)
treeframe:SetPoint("BottomLeft", mainframe, "BottomLeft", 0, 0)

local tree = treeframe:CreateTexture(nil, "Background")
tree:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Tree.tga")
tree:SetWidth(476)
tree:SetHeight(700)
tree:SetAlpha(0.99)
tree:SetBlendMode("Disable")
tree:SetDrawLayer("Background", 0)
tree:SetPoint("BottomLeft", treeframe, "BottomLeft", 0, 0)

local grave = mainframe:CreateTexture(nil, "Background")
grave:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Grave.tga")
grave:SetWidth(730)
grave:SetHeight(560)
grave:SetAlpha(0.99)
grave:SetBlendMode("Disable")
grave:SetDrawLayer("Background", 1)
grave:SetPoint("BottomRight", mainframe, "BottomRight", 0, 0)

local maskframe = CreateFrame("Frame", nil, mainframe)
maskframe:SetFrameStrata("Dialog")
maskframe:SetPoint("Center", 0, 0)
maskframe:SetWidth(1100)
maskframe:SetHeight(700)
maskframe:SetAlpha(1)

local gravemask = maskframe:CreateTexture(nil, "Background")
gravemask:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\GraveMask.tga")
gravemask:SetWidth(730)
gravemask:SetHeight(560)
gravemask:SetAlpha(0.99)
gravemask:SetBlendMode("Disable")
gravemask:SetDrawLayer("Background", 5)
gravemask:SetPoint("BottomRight", maskframe, "BottomRight", 0, 0)

local ghoulframe = CreateFrame("Frame", nil, mainframe)
ghoulframe:SetFrameStrata("High")
ghoulframe:SetWidth(800)
ghoulframe:SetHeight(800)
ghoulframe:SetAlpha(1)
ghoulframe:SetPoint("BottomRight", mainframe, "BottomRight", - 1, 1)

local ghoul = CreateFrame("PlayerModel", nil, ghoulframe)
ghoul:SetAllPoints(ghoulframe)

local dirt = maskframe:CreateTexture(nil, "Background")
dirt:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Dirt.tga")
dirt:SetWidth(150)
dirt:SetHeight(32)
dirt:SetAlpha(0.99)
dirt:SetBlendMode("Disable")
dirt:SetDrawLayer("Background", 6)
dirt:SetPoint("Bottom", gravemask, "Bottom", - 100, 38)
dirt:Hide()

local startframe = CreateFrame("Frame", nil, mainframe)
startframe:SetFrameStrata("High")
startframe:SetFrameLevel(2)
startframe:SetWidth(331)
startframe:SetHeight(146)
startframe:SetAlpha(1)
startframe:SetPoint("TopRight", grave, "TopRight", - 65, - 20)

local startshadow = mainframe:CreateTexture(nil, "Background")
startshadow:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\StartAdventureShadow.tga")
startshadow:SetWidth(350)
startshadow:SetHeight(150)
startshadow:SetAlpha(0.99)
startshadow:SetBlendMode("Disable")
startshadow:SetDrawLayer("Background", 2)
startshadow:SetPoint("Center", startframe, "Center", 0, 0)

local start = mainframe:CreateTexture(nil, "Background")
start:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\StartAdventure.tga")
start:SetWidth(331)
start:SetHeight(146)
start:SetAlpha(0.99)
start:SetBlendMode("Disable")
start:SetDrawLayer("Background", 3)
start:SetPoint("BottomLeft", startframe, "BottomLeft", 0, 0)

local minigamesframe = CreateFrame("Frame", nil, mainframe)
minigamesframe:SetFrameStrata("High")
minigamesframe:SetFrameLevel(3)
minigamesframe:SetWidth(313)
minigamesframe:SetHeight(133)
minigamesframe:SetAlpha(1)
minigamesframe:SetPoint("TopRight", grave, "TopRight", - 82, - 125)

local minigamesshadow = mainframe:CreateTexture(nil, "Background")
minigamesshadow:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\MiniGamesShadow.tga")
minigamesshadow:SetWidth(318)
minigamesshadow:SetHeight(136)
minigamesshadow:SetAlpha(0.99)
minigamesshadow:SetBlendMode("Disable")
minigamesshadow:SetDrawLayer("Background", 3)
minigamesshadow:SetPoint("Center", minigamesframe, "Center", 2, - 3)

local minigames = mainframe:CreateTexture(nil, "Background")
minigames:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\MiniGames.tga")
minigames:SetVertexColor(0.5, 0.5, 0.5)
minigames:SetWidth(313)
minigames:SetHeight(133)
minigames:SetAlpha(0.99)
minigames:SetBlendMode("Disable")
minigames:SetDrawLayer("Background", 4)
minigames:SetPoint("BottomLeft", minigamesframe, "BottomLeft", 0, 0)

minigamesframe:SetScript("OnEnter", function(self)
	minigames:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\MiniGamesHighlight.tga")
	if IsMouseButtonDown(1) then
		minigames:SetPoint("BottomLeft", minigamesframe, "BottomLeft", 2, 2)
		minigamesshadow:SetPoint("Center", minigamesframe, "Center", 2, - 1)
	else
		minigames:SetPoint("BottomLeft", minigamesframe, "BottomLeft", 0, 0)
		minigamesshadow:SetPoint("Center", minigamesframe, "Center", 2, - 3)
	end
	minigamesframe:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" then
			minigames:SetPoint("BottomLeft", minigamesframe, "BottomLeft", 0, 0)
			minigamesshadow:SetPoint("Center", minigamesframe, "Center", 2, - 3)
		end
	end)
end)

minigamesframe:SetScript("OnLeave", function(self)
	minigames:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\MiniGames.tga")
	minigames:SetPoint("BottomLeft", minigamesframe, "BottomLeft", 0, 0)
	minigamesshadow:SetPoint("Center", minigamesframe, "Center", 2, - 3)
	minigamesframe:SetScript("OnMouseUp", nil)
end)

minigamesframe:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		minigames:SetPoint("BottomLeft", minigamesframe, "BottomLeft", 2, 2)
		minigamesshadow:SetPoint("Center", minigamesframe, "Center", 2, - 1)
	end
end)

local puzzleframe = CreateFrame("Frame", nil, mainframe)
puzzleframe:SetFrameStrata("High")
puzzleframe:SetFrameLevel(4)
puzzleframe:SetWidth(286)
puzzleframe:SetHeight(122)
puzzleframe:SetAlpha(1)
puzzleframe:SetPoint("TopRight", grave, "TopRight", - 104, - 210)

local puzzleshadow = mainframe:CreateTexture(nil, "Background")
puzzleshadow:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\PuzzleShadow.tga")
puzzleshadow:SetWidth(289)
puzzleshadow:SetHeight(127)
puzzleshadow:SetAlpha(0.99)
puzzleshadow:SetBlendMode("Disable")
puzzleshadow:SetDrawLayer("Background", 4)
puzzleshadow:SetPoint("Center", puzzleframe, "Center", 2, - 3)

local puzzle = mainframe:CreateTexture(nil, "Background")
puzzle:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Puzzle.tga")
puzzle:SetVertexColor(0.5, 0.5, 0.5)
puzzle:SetWidth(286)
puzzle:SetHeight(122)
puzzle:SetAlpha(0.99)
puzzle:SetBlendMode("Disable")
puzzle:SetDrawLayer("Background", 5)
puzzle:SetPoint("BottomLeft", puzzleframe, "BottomLeft", 0, 0)

puzzleframe:SetScript("OnEnter", function(self)
	puzzle:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\PuzzleHighlight.tga")
	if IsMouseButtonDown(1) then
		puzzle:SetPoint("BottomLeft", puzzleframe, "BottomLeft", 2, 2)
		puzzleshadow:SetPoint("Center", puzzleframe, "Center", 2, - 1)
	else
		puzzle:SetPoint("BottomLeft", puzzleframe, "BottomLeft", 0, 0)
		puzzleshadow:SetPoint("Center", puzzleframe, "Center", 2, - 3)
	end
	puzzleframe:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" then
			puzzle:SetPoint("BottomLeft", puzzleframe, "BottomLeft", 0, 0)
			puzzleshadow:SetPoint("Center", puzzleframe, "Center", 2, - 3)
		end
	end)
end)

puzzleframe:SetScript("OnLeave", function(self)
	puzzle:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Puzzle.tga")
	puzzle:SetPoint("BottomLeft", puzzleframe, "BottomLeft", 0, 0)
	puzzleshadow:SetPoint("Center", puzzleframe, "Center", 2, - 3)
	puzzleframe:SetScript("OnMouseUp", nil)
end)

puzzleframe:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		puzzle:SetPoint("BottomLeft", puzzleframe, "BottomLeft", 2, 2)
		puzzleshadow:SetPoint("Center", puzzleframe, "Center", 2, - 1)
	end
end)

local survivalframe = CreateFrame("Frame", nil, mainframe)
survivalframe:SetFrameStrata("High")
survivalframe:SetFrameLevel(5)
survivalframe:SetWidth(266)
survivalframe:SetHeight(123)
survivalframe:SetAlpha(1)
survivalframe:SetPoint("TopRight", grave, "TopRight", - 124, - 280)

local survivalshadow = mainframe:CreateTexture(nil, "Background")
survivalshadow:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\SurvivalShadow.tga")
survivalshadow:SetWidth(269)
survivalshadow:SetHeight(127)
survivalshadow:SetAlpha(0.99)
survivalshadow:SetBlendMode("Disable")
survivalshadow:SetDrawLayer("Background", 5)
survivalshadow:SetPoint("Center", survivalframe, "Center", 6, - 3)

local survival = mainframe:CreateTexture(nil, "Background")
survival:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Survival.tga")
survival:SetVertexColor(0.5, 0.5, 0.5)
survival:SetWidth(266)
survival:SetHeight(123)
survival:SetAlpha(0.99)
survival:SetBlendMode("Disable")
survival:SetDrawLayer("Background", 6)
survival:SetPoint("BottomLeft", survivalframe, "BottomLeft", 0, 0)

survivalframe:SetScript("OnEnter", function(self)
	survival:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\SurvivalHighlight.tga")
	if IsMouseButtonDown(1) then
		survival:SetPoint("BottomLeft", survivalframe, "BottomLeft", 2, 2)
		survivalshadow:SetPoint("Center", survivalframe, "Center", 6, - 1)
	else
		survival:SetPoint("BottomLeft", survivalframe, "BottomLeft", 0, 0)
		survivalshadow:SetPoint("Center", survivalframe, "Center", 6, - 3)
	end
	survivalframe:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" then
			survival:SetPoint("BottomLeft", survivalframe, "BottomLeft", 0, 0)
			survivalshadow:SetPoint("Center", survivalframe, "Center", 6, - 3)
		end
	end)
end)

survivalframe:SetScript("OnLeave", function(self)
	survival:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Survival.tga")
	survival:SetPoint("BottomLeft", survivalframe, "BottomLeft", 0, 0)
	survivalshadow:SetPoint("Center", survivalframe, "Center", 6, - 3)
	survivalframe:SetScript("OnMouseUp", nil)
end)

survivalframe:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		survival:SetPoint("BottomLeft", survivalframe, "BottomLeft", 2, 2)
		survivalshadow:SetPoint("Center", survivalframe, "Center", 6, - 1)
	end
end)

local optionsframe = CreateFrame("Frame", nil, mainframe)
optionsframe:SetFrameStrata("High")
optionsframe:SetFrameLevel(6)
optionsframe:SetWidth(81)
optionsframe:SetHeight(31)
optionsframe:SetAlpha(1)
optionsframe:SetPoint("BottomRight", mainframe, "BottomRight", - 158, 80)

local options = mainframe:CreateTexture(nil, "Background")
options:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Options.tga")
options:SetWidth(81)
options:SetHeight(31)
options:SetAlpha(0.99)
options:SetBlendMode("Disable")
options:SetDrawLayer("Background", 6)
options:SetPoint("BottomLeft", optionsframe, "BottomLeft", 0, 0)

optionsframe:SetScript("OnEnter", function(self)
	options:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\OptionsHighlight.tga")
	if IsMouseButtonDown(1) then
		options:SetPoint("BottomLeft", optionsframe, "BottomLeft", 1, 1)
	else
		options:SetPoint("BottomLeft", optionsframe, "BottomLeft", 0, 0)
	end
	optionsframe:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" then
			PlantsVsGhouls:ToggleMenu()
			options:SetPoint("BottomLeft", optionsframe, "BottomLeft", 0, 0)
		end
	end)
end)

optionsframe:SetScript("OnLeave", function(self)
	options:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Options.tga")
	options:SetPoint("BottomLeft", optionsframe, "BottomLeft", 0, 0)
	optionsframe:SetScript("OnMouseUp", nil)
end)

optionsframe:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		options:SetPoint("BottomLeft", optionsframe, "BottomLeft", 1, 1)
	end
end)

local mainoptionspanelframe = CreateFrame("Frame", nil, mainframe)
mainoptionspanelframe:SetFrameStrata("Fullscreen")
mainoptionspanelframe:SetWidth(423)
mainoptionspanelframe:SetHeight(498)
mainoptionspanelframe:SetAlpha(1)
mainoptionspanelframe:SetPoint("Center", mainframe, "Center", 0, 0)
mainoptionspanelframe:Hide()

local quitframe = CreateFrame("Frame", nil, mainframe)
quitframe:SetFrameStrata("High")
quitframe:SetFrameLevel(6)
quitframe:SetWidth(47)
quitframe:SetHeight(27)
quitframe:SetAlpha(1)
quitframe:SetPoint("BottomRight", mainframe, "BottomRight", - 35, 60)

local quit = mainframe:CreateTexture(nil, "Background")
quit:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Quit.tga")
quit:SetWidth(47)
quit:SetHeight(27)
quit:SetAlpha(0.99)
quit:SetBlendMode("Disable")
quit:SetDrawLayer("Background", 6)
quit:SetPoint("BottomLeft", quitframe, "BottomLeft", 0, 0)

quitframe:SetScript("OnEnter", function(self)
	quit:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\QuitHighlight.tga")
	if IsMouseButtonDown(1) then
		quit:SetPoint("BottomLeft", quitframe, "BottomLeft", 1, 1)
	else
		quit:SetPoint("BottomLeft", quitframe, "BottomLeft", 0, 0)
	end
	quitframe:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" then
			if mainoptionspanelframe:IsVisible() then
				mainoptionspanelframe:Hide()
			end
			quit:SetPoint("BottomLeft", quitframe, "BottomLeft", 0, 0)
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\buttonclick.ogg", "Master")
			mainframe:Hide()
		end
	end)
end)

quitframe:SetScript("OnLeave", function(self)
	quit:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Quit.tga")
	quit:SetPoint("BottomLeft", quitframe, "BottomLeft", 0, 0)
	quitframe:SetScript("OnMouseUp", nil)
end)

quitframe:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		quit:SetPoint("BottomLeft", quitframe, "BottomLeft", 1, 1)
	end
end)

local leaves1 = maskframe:CreateTexture(nil, "Background")
leaves1:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Leaves.tga")
leaves1:SetWidth(240)
leaves1:SetHeight(62)
leaves1:SetAlpha(0.99)
leaves1:SetBlendMode("Disable")
leaves1:SetDrawLayer("Background", 6)
leaves1:SetPoint("BottomLeft", maskframe, "BottomLeft", 0, 0)

local leaves2 = maskframe:CreateTexture(nil, "Background")
leaves2:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Leaves.tga")
local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = leaves2:GetTexCoord()
leaves2:SetTexCoord(URx, URy, LRx, LRy, ULx, ULy, LLx, LLy)
leaves2:SetWidth(240)
leaves2:SetHeight(62)
leaves2:SetAlpha(0.99)
leaves2:SetBlendMode("Disable")
leaves2:SetDrawLayer("Background", 6)
leaves2:SetPoint("Left", leaves1, "Right", - 37, 0)

local flower1 = maskframe:CreateTexture(nil, "Background")
flower1:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Flower1.tga")
flower1:SetWidth(36)
flower1:SetHeight(47)
flower1:SetAlpha(0.99)
flower1:SetBlendMode("Disable")
flower1:SetDrawLayer("Background", 6)
flower1:SetPoint("BottomRight", maskframe, "BottomRight", - 80, 125)

local flower2 = maskframe:CreateTexture(nil, "Background")
flower2:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Flower2.tga")
flower2:SetWidth(43)
flower2:SetHeight(43)
flower2:SetAlpha(0.99)
flower2:SetBlendMode("Disable")
flower2:SetDrawLayer("Background", 6)
flower2:SetPoint("BottomRight", maskframe, "BottomRight", - 120, 125)

local flower3 = maskframe:CreateTexture(nil, "Background")
flower3:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Flower3.tga")
flower3:SetWidth(46)
flower3:SetHeight(53)
flower3:SetAlpha(0.99)
flower3:SetBlendMode("Disable")
flower3:SetDrawLayer("Background", 6)
flower3:SetPoint("BottomRight", maskframe, "BottomRight", - 20, 90)

local frame = CreateFrame("Frame", nil, UIParent)
frame:SetFrameStrata("High")
frame:SetPoint("Center", 0, 0)
frame:SetWidth(1100)
frame:SetHeight(600)
frame:SetAlpha(1)
frame:SetMovable(true)
frame:Hide()

function PlantsVsGhouls:InitModelGhoul()
	startframe:SetScript("OnEnter", nil)
	startframe:SetScript("OnLeave", nil)
	startframe:SetScript("OnMouseUp", nil)
	startframe:SetScript("OnMouseDown", nil)
	optionsframe:SetScript("OnEnter", nil)
	optionsframe:SetScript("OnLeave", nil)
	optionsframe:SetScript("OnMouseUp", nil)
	optionsframe:SetScript("OnMouseDown", nil)
	quitframe:SetScript("OnEnter", nil)
	quitframe:SetScript("OnLeave", nil)
	quitframe:SetScript("OnMouseUp", nil)
	quitframe:SetScript("OnMouseDown", nil)
	ghoul:SetDisplayInfo(547)
	ghoul:SetWidth(800)
	ghoul:SetHeight(800)
	ghoul:SetAlpha(1)
	ghoul:SetRotation(math.rad(75))
	ghoul:SetPosition(0, 0, - 0.3)
	local elapsed = 800
	local time = 0
	ghoul:SetScript("OnUpdate", function(self, elaps)
		ghoulframe:SetAlpha(1)
		if elapsed > 1050 then
			if not dirt:IsVisible() then
				dirt:Show()
			end
		end
		if elapsed < 2200 then
			elapsed = elapsed + (elaps * 800)
			time = time + (elaps * 800) 
			self:SetSequenceTime(127, elapsed)
		else
			self:SetSequenceTime(127, elapsed)
			ghoulframe:SetAlpha(0)
			dirt:Hide()
			ghoul:SetScript("OnUpdate", nil)
			mainframe:Hide()
			frame:Show()
			PlantsVsGhouls:InitAll()
			startframe:SetScript("OnEnter", function(self)
				start:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\StartAdventureHighlight.tga")
				if IsMouseButtonDown(1) then
					start:SetPoint("BottomLeft", startframe, "BottomLeft", 2, 2)
					startshadow:SetPoint("Center", startframe, "Center", 0, 2)
				else
					start:SetPoint("BottomLeft", startframe, "BottomLeft", 0, 0)
					startshadow:SetPoint("Center", startframe, "Center", 0, 0)
				end
				startframe:SetScript("OnMouseUp", function(self, button)
					if button == "LeftButton" then
						if mainoptionspanelframe:IsVisible() then
							mainoptionspanelframe:Hide()
						end
						start:SetPoint("BottomLeft", startframe, "BottomLeft", 0, 0)
						startshadow:SetPoint("Center", startframe, "Center", 0, 0)
						PlantsVsGhouls:InitModelGhoul()
						PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\losemusic.ogg", "Master")
					end
				end)
			end)
			startframe:SetScript("OnLeave", function(self)
				start:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\StartAdventure.tga")
				start:SetPoint("BottomLeft", startframe, "BottomLeft", 0, 0)
				startshadow:SetPoint("Center", startframe, "Center", 0, 0)
				startframe:SetScript("OnMouseUp", nil)
			end)
			startframe:SetScript("OnMouseDown", function(self, button)
				if button == "LeftButton" then
					start:SetPoint("BottomLeft", startframe, "BottomLeft", 2, 2)
					startshadow:SetPoint("Center", startframe, "Center", 0, 2)
				end
			end)
			optionsframe:SetScript("OnEnter", function(self)
				options:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\OptionsHighlight.tga")
				if IsMouseButtonDown(1) then
					options:SetPoint("BottomLeft", optionsframe, "BottomLeft", 1, 1)
				else
					options:SetPoint("BottomLeft", optionsframe, "BottomLeft", 0, 0)
				end
				optionsframe:SetScript("OnMouseUp", function(self, button)
					if button == "LeftButton" then
						PlantsVsGhouls:ToggleMenu()
						options:SetPoint("BottomLeft", optionsframe, "BottomLeft", 0, 0)
					end
				end)
			end)

			optionsframe:SetScript("OnLeave", function(self)
				options:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Options.tga")
				options:SetPoint("BottomLeft", optionsframe, "BottomLeft", 0, 0)
				optionsframe:SetScript("OnMouseUp", nil)
			end)

			optionsframe:SetScript("OnMouseDown", function(self, button)
				if button == "LeftButton" then
					options:SetPoint("BottomLeft", optionsframe, "BottomLeft", 1, 1)
				end
			end)
			quitframe:SetScript("OnEnter", function(self)
				quit:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\QuitHighlight.tga")
				if IsMouseButtonDown(1) then
					quit:SetPoint("BottomLeft", quitframe, "BottomLeft", 1, 1)
				else
					quit:SetPoint("BottomLeft", quitframe, "BottomLeft", 0, 0)
				end
				quitframe:SetScript("OnMouseUp", function(self, button)
					if button == "LeftButton" then
						if mainoptionspanelframe:IsVisible() then
							mainoptionspanelframe:Hide()
						end
						quit:SetPoint("BottomLeft", quitframe, "BottomLeft", 0, 0)
						PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\buttonclick.ogg", "Master")
						mainframe:Hide()
					end
				end)
			end)
			quitframe:SetScript("OnLeave", function(self)
				quit:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Quit.tga")
				quit:SetPoint("BottomLeft", quitframe, "BottomLeft", 0, 0)
				quitframe:SetScript("OnMouseUp", nil)
			end)
			quitframe:SetScript("OnMouseDown", function(self, button)
				if button == "LeftButton" then
					quit:SetPoint("BottomLeft", quitframe, "BottomLeft", 1, 1)
				end
			end)
			for i = 1, 5 do
				Ghouls[i].frame:SetPoint("Right", Plants[i][1].frame, "Right", Ghouls[i].model.pos, 10)
			end
		end
		if time > 100 then
			time = 0
			if start:GetTexture() == "Interface\\AddOns\\PlantsVsGhouls\\Textures\\StartAdventure" then
				start:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\StartAdventureHighlight.tga")
			else
				start:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\StartAdventure.tga")
			end
		end
	end)
end

startframe:SetScript("OnEnter", function(self)
	start:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\StartAdventureHighlight.tga")
	if IsMouseButtonDown(1) then
		start:SetPoint("BottomLeft", startframe, "BottomLeft", 2, 2)
		startshadow:SetPoint("Center", startframe, "Center", 0, 2)
	else
		start:SetPoint("BottomLeft", startframe, "BottomLeft", 0, 0)
		startshadow:SetPoint("Center", startframe, "Center", 0, 0)
	end
	startframe:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" then
			if mainoptionspanelframe:IsVisible() then
				mainoptionspanelframe:Hide()
			end
			start:SetPoint("BottomLeft", startframe, "BottomLeft", 0, 0)
			startshadow:SetPoint("Center", startframe, "Center", 0, 0)
			PlantsVsGhouls:InitModelGhoul()
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\losemusic.ogg", "Master")
		end
	end)
end)

startframe:SetScript("OnLeave", function(self)
	start:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\StartAdventure.tga")
	start:SetPoint("BottomLeft", startframe, "BottomLeft", 0, 0)
	startshadow:SetPoint("Center", startframe, "Center", 0, 0)
	startframe:SetScript("OnMouseUp", nil)
end)

startframe:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		start:SetPoint("BottomLeft", startframe, "BottomLeft", 2, 2)
		startshadow:SetPoint("Center", startframe, "Center", 0, 2)
	end
end)

mainframe:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		PlantsVsGhouls:FrameStartMoving(self, button)
	end
end)

mainframe:SetScript("OnMouseUp", function(self, button)
	if button == "LeftButton" then
		PlantsVsGhouls:FrameStopMoving(self, button)
	end
end)

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
		PlantsVsGhouls:FrameStartMoving(self, button)
	end
end)

frame:SetScript("OnMouseUp", function(self, button)
	if button == "LeftButton" then
		PlantsVsGhouls:FrameStopMoving(self, button)
	end
end)

local map = frame:CreateTexture(nil, "Background")
--map:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\BackgroundSun.tga")
map:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\BackgroundSunUnsodded.tga")
map:SetWidth(1100)
map:SetHeight(600)
map:SetAlpha(1)
map:SetBlendMode("Disable")
map:SetDrawLayer("Background", 0)
map:SetAllPoints(frame)
map:SetTexCoord(0, 0.785, 0, 1)

local view = CreateFrame("Frame", nil, UIParent)

local viewtimer = 0
local viewCompleted = 0
local viewCompleted2 = 0.215
local holdtimer = 0

function PlantsVsGhouls:ViewOnUpdate(elapsed)
	viewtimer = viewtimer + elapsed
	if viewtimer < 0.005 then
		return
	end
	viewtimer = 0
	if holdtimer < 1.5 then
		holdtimer = holdtimer + elapsed
	else
		if viewCompleted >= 0.215 then
			if viewCompleted2 < 0 then
				map:SetTexCoord(0, 0.785, 0, 1)
				view:SetScript("OnUpdate", nil)
				frame:SetScript("OnUpdate", PlantsVsGhouls.FrameOnUpdate)
			else
				if holdtimer > 3 then
					viewCompleted2 = viewCompleted2 - 0.002
					map:SetTexCoord(0 + viewCompleted2, 0.785 + viewCompleted2, 0, 1)
				else
					holdtimer = holdtimer + elapsed
				end
			end
		else
			viewCompleted = viewCompleted + 0.002
			map:SetTexCoord(0 + viewCompleted, 0.785 + viewCompleted, 0, 1)
		end
	end
end

local sodonerowframe = CreateFrame("Frame", nil, frame)
sodonerowframe:SetFrameStrata("High")
sodonerowframe:SetWidth(770)
sodonerowframe:SetHeight(127)
sodonerowframe:SetAlpha(1)
sodonerowframe:SetPoint("Left", frame, "Left", 239, - 29)
sodonerowframe:Hide()

local sodonerow = sodonerowframe:CreateTexture(nil, "Background")
sodonerow:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\SodOneRow.tga")
sodonerow:SetWidth(770)
sodonerow:SetHeight(127)
sodonerow:SetAlpha(0.99)
sodonerow:SetBlendMode("Disable")
sodonerow:SetDrawLayer("Background", 2)
sodonerow:SetAllPoints(sodonerowframe)

local sodendcap = sodonerowframe:CreateTexture(nil, "Background")
sodendcap:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\SodEndCap.tga")
sodendcap:SetSize(72 * math.sqrt(2), 72 * math.sqrt(2))
sodendcap:SetRotation(math.rad(0))
sodendcap:SetAlpha(0.99)
sodendcap:SetBlendMode("Disable")
sodendcap:SetDrawLayer("Background", 6)
sodendcap:SetPoint("Bottom", sodonerow, "BottomRight", 0, - 10)
sodendcap:Hide()

local sodend = sodonerowframe:CreateTexture(nil, "Background")
sodend:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\SodEnd.tga")
sodend:SetWidth(57)
sodend:SetHeight(110)
sodend:SetAlpha(0.99)
sodend:SetBlendMode("Disable")
sodend:SetDrawLayer("Background", 4)
sodend:SetPoint("Bottom", sodendcap, "Center", 0, 0)
sodend:Hide()

local anim = CreateFrame("Frame", nil, UIParent)

local frametimer = 0
local percentCompleted = 0

function PlantsVsGhouls:FrameOnUpdate(elapsed)
	frametimer = frametimer + elapsed
	if frametimer < 0.005 then
		return
	end
	frametimer = 0
	local size = 770
	percentCompleted = percentCompleted + 0.004
	if percentCompleted >= 1 then
		sodendcap:Hide()
		sodend:Hide()
		sodendcap:SetSize(72 * math.sqrt(2), 72 * math.sqrt(2))
		sodend:SetWidth(60)
		frame:SetScript("OnUpdate", nil)
		anim:SetScript("OnUpdate", PlantsVsGhouls.AnimOnUpdate)
	else
		sodonerowframe:Show()
		sodendcap:Show()
		sodend:Show()
		sodendcap:SetSize(sodendcap:GetWidth() * (1 - (percentCompleted / 150)), sodendcap:GetHeight() * (1 - (percentCompleted / 150)))
		sodendcap:SetRotation(math.rad(0 + (percentCompleted * - 2000)))
		sodend:SetWidth(sodend:GetWidth() * (1 - (percentCompleted / 150)))
		sodonerowframe:SetWidth(size * percentCompleted)
		sodonerow:SetTexCoord(0, 0 + percentCompleted, 0, 1)
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

local overlayframe = CreateFrame("Frame", nil, frame)
overlayframe:SetFrameStrata("Fullscreen")
overlayframe:SetWidth(300)
overlayframe:SetHeight(133)
overlayframe:SetAlpha(1)
overlayframe:SetPoint("Center", frame, "Center", 0, 0)

local ready = overlayframe:CreateTexture(nil, "Background")
ready:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Ready.tga")
ready:SetWidth(300)
ready:SetHeight(133)
ready:SetAlpha(0.99)
ready:SetBlendMode("Disable")
ready:SetDrawLayer("Background", 0)
ready:SetAllPoints(overlayframe)
ready:Hide()

local set = overlayframe:CreateTexture(nil, "Background")
set:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Set.tga")
set:SetWidth(300)
set:SetHeight(133)
set:SetAlpha(0.99)
set:SetBlendMode("Disable")
set:SetDrawLayer("Background", 0)
set:SetAllPoints(overlayframe)
set:Hide()

local plant = overlayframe:CreateTexture(nil, "Background")
plant:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Plant!.tga")
plant:SetWidth(300)
plant:SetHeight(133)
plant:SetAlpha(0.99)
plant:SetBlendMode("Disable")
plant:SetDrawLayer("Background", 0)
plant:SetAllPoints(overlayframe)
plant:Hide()

local animtimer = 0
local animtimer2 = 0

function PlantsVsGhouls:AnimOnUpdate(elapsed)
	animtimer = animtimer + elapsed
	if animtimer < 0.005 then
		return
	end
	animtimer = 0
	animtimer2 = animtimer2 + elapsed
	if animtimer2 < 0.5 then
		if not ready:IsVisible() then
			ready:Show()
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\readysetplant.ogg", "Master")
		end
	elseif animtimer2 > 0.7 and animtimer2 < 1.2 then
		if ready:IsVisible() then
			ready:Hide()
		end
		if not set:IsVisible() then
			set:Show()
		end
	elseif animtimer2 > 1.4 and animtimer2 < 1.9 then
		if ready:IsVisible() then
			ready:Hide()
		end
		if set:IsVisible() then
			set:Hide()
		end
		if not plant:IsVisible() then
			plant:Show()
		end
	elseif animtimer2 > 1.9 then
		if ready:IsVisible() then
			ready:Hide()
		end
		if set:IsVisible() then
			set:Hide()
		end
		if plant:IsVisible() then
			plant:Hide()
		end
		anim:SetScript("OnUpdate", nil)
		GameStarted = true
	else
		plant:Hide()
	end
end

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
	sunmodel:SetPosition(1 / (UIParentScale * UIParentScale * UIParentScale), 0, 0.45 / (UIParentScale * UIParentScale * UIParentScale))
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
		cursortemp:SetPosition(4.18 / UIParentScale, 0.03 / UIParentScale, 1.793 / UIParentScale)
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
	modelslotx:SetPosition(4.18 / UIParentScale, 0.03 / UIParentScale, 1.793 / UIParentScale)
	modelslotx:SetRotation(math.rad(128))
	modelslotx:SetAllPoints(slotx)
end

modelslotx:SetScript("OnMouseDown", function(self, button)
	if GameStarted and not GamePaused then
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
		if Debug == true then
			Plants[i][j].frame:SetBackdrop(SlotBackdrop)
			Plants[i][j].frame:SetBackdropColor(0.2, 0.7, 0.2, 0.5)
		end
		Plants[i][j].frame.x = Plants[i][j].frame:GetWidth() / 2
		Plants[i][j].frame.y = Plants[i][j].frame:GetHeight() / 2.5
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
	Ghouls[i].frame:SetPoint("Right", Plants[i][1].frame, "Right", 900, 10)
	Ghouls[i].frame:SetAlpha(1)
	Ghouls[i].frame:SetWidth(200)
	Ghouls[i].frame:SetHeight(200)
	if Debug == true then
		Ghouls[i].frame:SetBackdrop(SlotBackdrop)
		Ghouls[i].frame:SetBackdropColor(0.8, 0.2, 0.2, 0.5)
	end
	Ghouls[i].model = CreateFrame("PlayerModel", nil, Ghouls[i].frame)
	Ghouls[i].model:SetAllPoints(Ghouls[i].frame)
end

for i = 1, 5 do
	Sun[i].frame = CreateFrame("Frame", nil, frame)
	Sun[i].frame:SetFrameStrata("High")
	if i == 1 then
		Sun[i].frame:SetPoint("Bottom", Plants[1][i].frame, "Top", 0, 100)
	elseif i == 2 then
		Sun[i].frame:SetPoint("Bottom", Plants[1][i + 1].frame, "Top", 0, 100)
	elseif i == 3 then
		Sun[i].frame:SetPoint("Bottom", Plants[1][i + 2].frame, "Top", 0, 100)
	elseif i == 4 then
		Sun[i].frame:SetPoint("Bottom", Plants[1][i + 3].frame, "Top", 0, 100)
	elseif i == 5 then
		Sun[i].frame:SetPoint("Bottom", Plants[1][i + 4].frame, "Top", 0, 100)
	end
	Sun[i].frame:SetAlpha(1)
	Sun[i].frame:SetWidth(150)
	Sun[i].frame:SetHeight(150)
	if Debug == true then
		Sun[i].frame:SetBackdrop(SlotBackdrop)
		Sun[i].frame:SetBackdropColor(0.8, 0.8, 0.2, 0.5)
	end
	Sun[i].model = CreateFrame("PlayerModel", nil, Sun[i].frame)
	Sun[i].model:SetAllPoints(Sun[i].frame)
end

function PlantsVsGhouls:InitModelSuns(model)
	model:SetModel("Spells\\druid_wrath_missile_v2.m2")
	model:SetAlpha(1)
	model:SetWidth(150)
	model:SetHeight(150)
	model:SetPosition(2, 0, 0.9)
end

function PlantsVsGhouls:SlotOnMouseDown(button, model, cooldown)
	if GameStarted and not GamePaused and (not cooldown.start or GetTime() > (cooldown.start + PlantTypes[model.type].cooldown)) then
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
		for i = 1, #Ghouls do
			if CurrentLine == Ghouls[i].model.line and self:GetDistance(Plants[CurrentLine][CurrentRow].frame, Ghouls[CurrentLine].model) > Ghouls[CurrentLine].model.startpos and self:GetDistance(Plants[CurrentLine][CurrentRow].frame, Ghouls[CurrentLine].model) < Ghouls[CurrentLine].model.endpos then
				Ghouls[CurrentLine].model.next = CurrentRow
			end
		end
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
			if GameStarted and not GamePaused then
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
			if GameStarted and not GamePaused then
				elapsed = elapsed + (elaps * 600)
				model:SetSequenceTime(anim, elapsed)
				if anim == 5 then
					if model.type == 1 then
						if model.z == 0 or Ghouls[model.line].frame:GetRight() * WindowScale > frame:GetRight() then
							Ghouls[model.line].frame:SetPoint("Right", Plants[model.line][1].frame, "Right", model.pos, 10)
						else
							if model.z < 0 then
								model:SetPosition(model.z, 0.7, 0)
							else
								model.z = 0
								model:SetPosition(model.z, 0.7, 0)
							end
						end
					elseif model.type == 2 or model.type == 3 then
						if model.z == 0 or Ghouls[model.line].frame:GetRight() * WindowScale > frame:GetRight() then
							Ghouls[model.line].frame:SetPoint("Right", Plants[model.line][1].frame, "Right", model.pos, 10)
						else
							if model.z < 0 then
								model:SetPosition(model.z, 0.7, 0)
							else
								model.z = 0
								model:SetPosition(model.z, 0.7, 0)
							end
						end
					end
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
						if model.type == 1 then
							if model.z == 0 or Ghouls[model.line].frame:GetRight() * WindowScale > frame:GetRight() then
								model.pos = model.pos - model.speed
							else
								model.z = model.z + (model.speed / 50)
							end
						elseif model.type == 2 or model.type == 3 then
							if model.z == 0 or Ghouls[model.line].frame:GetRight() * WindowScale > frame:GetRight() then
								model.pos = model.pos - model.speed
							else
								model.z = model.z + (model.speed / 50)
							end
						end
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

function PlantsVsGhouls:InitModelGhouls(model, type, createdline, skip)
	if not skip then
		model.type = type
		model.line = createdline
		model.next = 9
		model.pos = 900 + math.random(50, 150)
	end
	if not skip then
		local r = math.random((#GhoulTypes[type].model))
		model:SetDisplayInfo(GhoulTypes[type].model[r])
		model.id = GhoulTypes[type].model[r]
	else
		if model.id then
			model:SetDisplayInfo(model.id)
		end
	end
	if not skip then
		model.distance = GhoulTypes[type].distance * UIParentScale
		model.yaw = GhoulTypes[type].yaw
		model.pitch = GhoulTypes[type].pitch
		model.startpos = GhoulTypes[type].startpos
		model.endpos = GhoulTypes[type].endpos
		model.stoppos = GhoulTypes[type].stoppos
		model.speed = GhoulTypes[type].speed
		model.damage = GhoulTypes[type].damage
	end
	model:SetWidth(200)
	model:SetHeight(200)
	model:SetAlpha(1)
	model:SetCustomCamera(1)
	self:SetOrientation(model)
	if not skip then
		if type == 1 then
			model.z = - 3.75
			model:SetPosition(model.z, 0.7, 0)
		elseif type == 2 or type == 3 then
			model.z = - 3.75
			model:SetPosition(model.z, 0.7, 0)
		end
		self:ChangeGhoulAnimation(model, 5)
	end
end

function PlantsVsGhouls:GetDistance(obj1, obj2)
	return obj2:GetLeft() - (obj1:GetLeft() + obj1:GetWidth())
end

function PlantsVsGhouls:GetBaseCameraTarget(model)
	if model:GetObjectType() ~= "PlayerModel" then
		if Debug then
			print("Not \"PlayerModel\" type!")
		end
		return
	end
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

function PlantsVsGhouls:SetOrientation(model, target)
	if model:GetObjectType() ~= "PlayerModel" then
		if Debug then
			print("Not \"PlayerModel\" type!")
		end
		return
	end
	if model:HasCustomCamera() and model.distance and model.yaw and model.pitch then
		local x = model.distance * math.cos(model.yaw) * math.cos(model.pitch)
		local y = model.distance * math.sin(- model.yaw) * math.cos(model.pitch)
		local z = (model.distance * math.sin(- model.pitch))
		model:SetCameraPosition(x, y, z)
		if not target then
			local x, y, z = self:GetBaseCameraTarget(model)
			if x and y and z then
				model:SetCameraTarget(0, 0, 0)
			end
		end
	else
		if Debug then
			print("Model has no custom camera!")
		end
	end
end

function PlantsVsGhouls:SetModelTilt(model, tiltdegree)
	if model:GetObjectType() ~= "PlayerModel" then
		if Debug then
			print("Not \"PlayerModel\" type!")
		end
		return
	end
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
		local x, y, z = self:GetBaseCameraTarget(model)
		if y and z then
			model:SetCameraTarget(0, y, z)
		end
	else
		if Debug then
			print("Model has no custom camera!")
		end
	end
end

function PlantsVsGhouls:FrameStartMoving(frame, button)
	if button == "LeftButton" then
		frame:StartMoving()
	end
end

function PlantsVsGhouls:FrameStopMoving(frame, button)
	frame:StopMovingOrSizing()
end

function PlantsVsGhouls:DisableModes()
	self:ClearCursorTemp()
	self:ClearTemp()
	PlantMode = false
	DestroyMode = false
end

local font1 = "Interface\\AddOns\\PlantsVsGhouls\\Fonts\\Samdan.ttf"
local font2 = "Interface\\AddOns\\PlantsVsGhouls\\Fonts\\Serio.ttf"
local font3 = "Interface\\AddOns\\PlantsVsGhouls\\Fonts\\Dwarven.ttf"

local menu = CreateFrame("Button", nil, frame)
menu:SetPoint("TopRight", frame, "TopRight", - 220, 0)
menu:SetWidth(120)
menu:SetHeight(35)
menu:SetHitRectInsets(1, 1, 2, 4)
menu:SetNormalTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Button.tga")
menu:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\ButtonDown.tga")
local menutext = menu:CreateFontString(nil, "Artwork")
menutext:SetFont(font2, 13, "Outline")
menutext:SetTextColor(1, 1, 1, 1)
menutext:SetText("Menu")
menutext:SetPoint("Center", menu, "Center", 0, 0)

menu:SetScript("OnEnter", function(self, button)
	if IsMouseButtonDown(1) then
		menu:SetNormalTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\ButtonDown.tga")
		menu:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\ButtonDown.tga")
		menutext:SetPoint("Center", menu, "Center", 1, - 1)
	else
		menu:SetNormalTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Button.tga")
		menu:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Button.tga")
		menutext:SetPoint("Center", menu, "Center", 0, 0)
	end
	menutext:SetTextColor(0, 1, 0, 1)
	menu:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" then
			PlantsVsGhouls:ToggleMenu()
			menutext:SetPoint("Center", menu, "Center", 0, 0)
		end
	end)
end)

menu:SetScript("OnLeave", function(self, button)
	menu:SetNormalTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Button.tga")
	menu:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Button.tga")
	menutext:SetPoint("Center", menu, "Center", 0, 0)
	menutext:SetTextColor(1, 1, 1, 1)
	menu:SetScript("OnMouseUp", nil)
end)

menu:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		menu:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\ButtonDown.tga")
		menutext:SetPoint("Center", menu, "Center", 1, - 1)
	else
		menu:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Button.tga")
	end
end)

local optionspanelframe = CreateFrame("Frame", nil, frame)
optionspanelframe:SetFrameStrata("Fullscreen")
optionspanelframe:SetWidth(423)
optionspanelframe:SetHeight(498)
optionspanelframe:SetAlpha(1)
optionspanelframe:SetPoint("Center", frame, "Center", 0, 0)
optionspanelframe:Hide()

local mainoptionspanel = mainoptionspanelframe:CreateTexture(nil, "Background")
mainoptionspanel:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\OptionsPanel.tga")
mainoptionspanel:SetWidth(423)
mainoptionspanel:SetHeight(498)
mainoptionspanel:SetAlpha(0.99)
mainoptionspanel:SetBlendMode("Disable")
mainoptionspanel:SetDrawLayer("Background", 0)
mainoptionspanel:SetAllPoints(mainoptionspanelframe)

local mainback = CreateFrame("Button", nil, mainoptionspanelframe)
mainback:SetPoint("Bottom", mainoptionspanelframe, "Bottom", 0, 15)
mainback:SetWidth(360)
mainback:SetHeight(100)
mainback:SetHitRectInsets(1, 1, 2, 4)
mainback:SetNormalTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\OptionsPanelBackButton.tga")
mainback:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\OptionsPanelBackButtonDown.tga")
local mainbacktext = mainback:CreateFontString(nil, "Artwork")
mainbacktext:SetFont(font3, 62, "Outline")
mainbacktext:SetTextColor(1, 1, 1, 1)
mainbacktext:SetText("Ok")
mainbacktext:SetPoint("Center", mainback, "Center", 0, 0)

mainback:SetScript("OnEnter", function(self, button)
	if IsMouseButtonDown(1) then
		mainback:SetNormalTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\OptionsPanelBackButtonDown.tga")
		mainback:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\OptionsPanelBackButtonDown.tga")
		mainbacktext:SetPoint("Center", mainback, "Center", 0, - 1)
	else
		mainback:SetNormalTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\OptionsPanelBackButton.tga")
		mainback:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\OptionsPanelBackButton.tga")
		mainbacktext:SetPoint("Center", mainback, "Center", 0, 0)
	end
	mainbacktext:SetTextColor(0, 1, 0, 1)
	mainback:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" then
			if mainoptionspanelframe:IsVisible() then
				mainoptionspanelframe:Hide()
			end
			mainbacktext:SetPoint("Center", mainback, "Center", 0, 0)
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\buttonclick.ogg", "Master")
		end
	end)
end)

mainback:SetScript("OnLeave", function(self, button)
	mainback:SetNormalTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\OptionsPanelBackButton.tga")
	mainback:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\OptionsPanelBackButton.tga")
	mainbacktext:SetPoint("Center", mainback, "Center", 0, 0)
	mainbacktext:SetTextColor(1, 1, 1, 1)
	mainback:SetScript("OnMouseUp", nil)
end)

mainback:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		mainback:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\OptionsPanelBackButtonDown.tga")
		mainbacktext:SetPoint("Center", mainback, "Center", 0, - 1)
	else
		mainback:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\OptionsPanelBackButton.tga")
	end
end)

function PlantsVsGhouls:ToggleMenu()
	if not GameStarted then
		if mainframe:IsVisible() then
			if mainoptionspanelframe:IsVisible() then
				mainoptionspanelframe:Hide()
				PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\buttonclick.ogg", "Master")
			else
				mainoptionspanelframe:Show()
				PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\pause.ogg", "Master")
			end
		else
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\buzzer.ogg", "Master")
		end
		return
	end
	if optionspanelframe:IsVisible() then
		optionspanelframe:Hide()
		self:ResumeGame()
		PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\buttonclick.ogg", "Master")
	else
		optionspanelframe:Show()
		self:PauseGame()
		PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\pause.ogg", "Master")
	end
end

local optionspanel = optionspanelframe:CreateTexture(nil, "Background")
optionspanel:SetTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\OptionsPanel.tga")
optionspanel:SetWidth(423)
optionspanel:SetHeight(498)
optionspanel:SetAlpha(0.99)
optionspanel:SetBlendMode("Disable")
optionspanel:SetDrawLayer("Background", 0)
optionspanel:SetAllPoints(optionspanelframe)

local back = CreateFrame("Button", nil, optionspanelframe)
back:SetPoint("Bottom", optionspanelframe, "Bottom", 0, 15)
back:SetWidth(360)
back:SetHeight(100)
back:SetHitRectInsets(1, 1, 2, 4)
back:SetNormalTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\OptionsPanelBackButton.tga")
back:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\OptionsPanelBackButtonDown.tga")
local backtext = back:CreateFontString(nil, "Artwork")
backtext:SetFont(font3, 62, "Outline")
backtext:SetTextColor(1, 1, 1, 1)
backtext:SetText("Back To Game")
backtext:SetPoint("Center", back, "Center", 0, 0)

back:SetScript("OnEnter", function(self, button)
	if IsMouseButtonDown(1) then
		back:SetNormalTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\OptionsPanelBackButtonDown.tga")
		back:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\OptionsPanelBackButtonDown.tga")
		backtext:SetPoint("Center", back, "Center", 0, - 1)
	else
		back:SetNormalTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\OptionsPanelBackButton.tga")
		back:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\OptionsPanelBackButton.tga")
		backtext:SetPoint("Center", back, "Center", 0, 0)
	end
	backtext:SetTextColor(0, 1, 0, 1)
	back:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" then
			optionspanelframe:Hide()
			backtext:SetPoint("Center", back, "Center", 0, 0)
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\buttonclick.ogg", "Master")
			PlantsVsGhouls:ResumeGame()
		end
	end)
end)

back:SetScript("OnLeave", function(self, button)
	back:SetNormalTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\OptionsPanelBackButton.tga")
	back:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\OptionsPanelBackButton.tga")
	backtext:SetPoint("Center", back, "Center", 0, 0)
	backtext:SetTextColor(1, 1, 1, 1)
	back:SetScript("OnMouseUp", nil)
end)

back:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		back:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\OptionsPanelBackButtonDown.tga")
		backtext:SetPoint("Center", back, "Center", 0, - 1)
	else
		back:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\OptionsPanelBackButton.tga")
	end
end)

local mainmenu = CreateFrame("Button", nil, optionspanelframe)
mainmenu:SetPoint("Bottom", optionspanel, "Bottom", 0, 130)
mainmenu:SetWidth(200)
mainmenu:SetHeight(45)
mainmenu:SetHitRectInsets(1, 1, 2, 4)
mainmenu:SetNormalTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Button.tga")
mainmenu:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\ButtonDown.tga")
local mainmenutext = mainmenu:CreateFontString(nil, "Artwork")
mainmenutext:SetFont(font3, 18, "Outline")
mainmenutext:SetTextColor(1, 1, 1, 1)
mainmenutext:SetText("Main Menu")
mainmenutext:SetPoint("Center", mainmenu, "Center", 0, 0)

mainmenu:SetScript("OnEnter", function(self, button)
	if IsMouseButtonDown(1) then
		mainmenu:SetNormalTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\ButtonDown.tga")
		mainmenu:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\ButtonDown.tga")
		mainmenutext:SetPoint("Center", mainmenu, "Center", 1, - 1)
	else
		mainmenu:SetNormalTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Button.tga")
		mainmenu:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Button.tga")
		mainmenutext:SetPoint("Center", mainmenu, "Center", 0, 0)
	end
	mainmenutext:SetTextColor(0, 1, 0, 1)
	mainmenu:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" then
			mainmenutext:SetPoint("Center", mainmenu, "Center", 0, 0)
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\buttonclick.ogg", "Master")
			PlantsVsGhouls:Mainmenu()
		end
	end)
end)

mainmenu:SetScript("OnLeave", function(self, button)
	mainmenu:SetNormalTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Button.tga")
	mainmenu:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Button.tga")
	mainmenutext:SetPoint("Center", mainmenu, "Center", 0, 0)
	mainmenutext:SetTextColor(1, 1, 1, 1)
	mainmenu:SetScript("OnMouseUp", nil)
end)

mainmenu:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		mainmenu:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\ButtonDown.tga")
		mainmenutext:SetPoint("Center", mainmenu, "Center", 1, - 1)
	else
		mainmenu:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Button.tga")
	end
end)

local restart = CreateFrame("Button", nil, optionspanelframe)
restart:SetPoint("Bottom", optionspanel, "Bottom", 0, 170)
restart:SetWidth(200)
restart:SetHeight(45)
restart:SetHitRectInsets(1, 1, 2, 4)
restart:SetNormalTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Button.tga")
restart:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\ButtonDown.tga")
local restarttext = restart:CreateFontString(nil, "Artwork")
restarttext:SetFont(font3, 18, "Outline")
restarttext:SetTextColor(1, 1, 1, 1)
restarttext:SetText("Restart Game")
restarttext:SetPoint("Center", restart, "Center", 0, 0)

restart:SetScript("OnEnter", function(self, button)
	if IsMouseButtonDown(1) then
		restart:SetNormalTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\ButtonDown.tga")
		restart:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\ButtonDown.tga")
		restarttext:SetPoint("Center", restart, "Center", 1, - 1)
	else
		restart:SetNormalTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Button.tga")
		restart:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Button.tga")
		restarttext:SetPoint("Center", restart, "Center", 0, 0)
	end
	restarttext:SetTextColor(0, 1, 0, 1)
	restart:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" then
			restarttext:SetPoint("Center", restart, "Center", 0, 0)
			PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\buttonclick.ogg", "Master")
			PlantsVsGhouls:RestartLevel()
		end
	end)
end)

restart:SetScript("OnLeave", function(self, button)
	restart:SetNormalTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Button.tga")
	restart:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Button.tga")
	restarttext:SetPoint("Center", restart, "Center", 0, 0)
	restarttext:SetTextColor(1, 1, 1, 1)
	restart:SetScript("OnMouseUp", nil)
end)

restart:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		restart:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\ButtonDown.tga")
		restarttext:SetPoint("Center", restart, "Center", 1, - 1)
	else
		restart:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Button.tga")
	end
end)

local pause = CreateFrame("Button", nil, frame)
pause:SetPoint("TopRight", frame, "TopRight", - 100, 0)
pause:SetWidth(120)
pause:SetHeight(35)
pause:SetHitRectInsets(1, 1, 2, 4)
pause:SetNormalTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Button.tga")
pause:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\ButtonDown.tga")
local pausetext = pause:CreateFontString(nil, "Artwork")
pausetext:SetFont(font2, 13, "Outline")
pausetext:SetTextColor(1, 1, 1, 1)
pausetext:SetText("Pause")
pausetext:SetPoint("Center", pause, "Center", 0, 0)

pause:SetScript("OnEnter", function(self, button)
	if IsMouseButtonDown(1) then
		pause:SetNormalTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\ButtonDown.tga")
		pause:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\ButtonDown.tga")
		pausetext:SetPoint("Center", pause, "Center", 1, - 1)
	else
		pause:SetNormalTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Button.tga")
		pause:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Button.tga")
		pausetext:SetPoint("Center", pause, "Center", 0, 0)
	end
	pausetext:SetTextColor(0, 1, 0, 1)
	pause:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" then
			if optionspanelframe:IsVisible() then
				optionspanelframe:Hide()
			end
			PlantsVsGhouls:TogglePause()
			pausetext:SetPoint("Center", pause, "Center", 0, 0)
		end
	end)
end)

pause:SetScript("OnLeave", function(self, button)
	pause:SetNormalTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Button.tga")
	pause:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Button.tga")
	pausetext:SetPoint("Center", pause, "Center", 0, 0)
	pausetext:SetTextColor(1, 1, 1, 1)
	pause:SetScript("OnMouseUp", nil)
end)

pause:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		pause:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\ButtonDown.tga")
		pausetext:SetPoint("Center", pause, "Center", 1, - 1)
	else
		pause:SetPushedTexture("Interface\\AddOns\\PlantsVsGhouls\\Textures\\Button.tga")
	end
end)

function PlantsVsGhouls:Mainmenu()
	if optionspanelframe:IsVisible() then
		optionspanelframe:Hide()
	end
	self:ClearLevel()
	for i = 1, 5 do
		local r = math.random(3)
		self:InitModelGhouls(Ghouls[i].model, r, i)
		Ghouls[i].frame:SetPoint("Right", Plants[i][1].frame, "Right", Ghouls[i].model.pos, 10)
		Ghouls[i].model.distance = GhoulTypes[Ghouls[i].model.type].distance * UIParentScale * WindowScale
		self:SetOrientation(Ghouls[i].model, true)
		Ghouls[i].model:SetPosition(Ghouls[i].model.z / WindowScale, 0.7, 0)
	end
	GamePaused = false
	GameStarted = false
	sodendcap:SetSize(72 * math.sqrt(2), 72 * math.sqrt(2))
	sodend:SetWidth(60)
	percentCompleted = 0
	sodonerowframe:Hide()
	viewtimer = 0
	viewCompleted = 0
	viewCompleted2 = 0.215
	holdtimer = 0
	animtimer = 0
	animtimer2 = 0
	frame:Hide()
	self:InitModelSky()
	mainframe:Show()
	pausetext:SetText("Pause")
end

function PlantsVsGhouls:RestartLevel()
	if optionspanelframe:IsVisible() then
		optionspanelframe:Hide()
	end
	self:ClearLevel()
	for i = 1, 5 do
		local r = math.random(3)
		self:InitModelGhouls(Ghouls[i].model, r, i)
		Ghouls[i].frame:SetPoint("Right", Plants[i][1].frame, "Right", Ghouls[i].model.pos, 10)
		Ghouls[i].model.distance = GhoulTypes[Ghouls[i].model.type].distance * UIParentScale * WindowScale
		self:SetOrientation(Ghouls[i].model, true)
		Ghouls[i].model:SetPosition(Ghouls[i].model.z / WindowScale, 0.7, 0)
	end
	GamePaused = false
	GameStarted = false
	sodendcap:SetSize(72 * math.sqrt(2), 72 * math.sqrt(2))
	sodend:SetWidth(60)
	percentCompleted = 0
	sodonerowframe:Hide()
	viewtimer = 0
	viewCompleted = 0
	viewCompleted2 = 0.215
	holdtimer = 0
	view:SetScript("OnUpdate", PlantsVsGhouls.ViewOnUpdate)
	animtimer = 0
	animtimer2 = 0
	pausetext:SetText("Pause")
end

function PlantsVsGhouls:ClearLevel()
	for i = 1, 5 do
		for j = 1, 9 do
			Plants[i][j].model.type = nil
			Plants[i][j].model:ClearModel()
		end
	end
	for i = 1, 5 do
		Ghouls[i].model:ClearModel()
	end
end

function PlantsVsGhouls:TogglePause()
	if not GameStarted then
		PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\buzzer.ogg", "Master")
		return
	end
	if GamePaused then
		self:ResumeGame()
		PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\buttonclick.ogg", "Master")
	else
		self:PauseGame()
		PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\pause.ogg", "Master")
	end
end

function PlantsVsGhouls:PauseGame()
	GamePaused = true
	self:DisableModes()
	self:ClearCursorTemp()
	self:ClearTemp()
	local time = GetTime()
	for i = 1, 5 do
		Slots[i].cooldown:Hide()
		if Slots[i].cooldown.start and time <= (Slots[i].cooldown.start + PlantTypes[Slots[i].model.type].cooldown) then
			Slots[i].cooldown.remains = PlantTypes[Slots[i].model.type].cooldown - (time - Slots[i].cooldown.start)
		end
	end
	pausetext:SetText("Resume")
end

function PlantsVsGhouls:ResumeGame()
	GamePaused = false
	local time = GetTime()
	for i = 1, 5 do
		Slots[i].cooldown:Show()
		if Slots[i].cooldown.start and time <= (Slots[i].cooldown.start + PlantTypes[Slots[i].model.type].cooldown) then
			Slots[i].cooldown:SetCooldown(time, Slots[i].cooldown.remains)
			Slots[i].cooldown.start = time - (PlantTypes[Slots[i].model.type].cooldown - Slots[i].cooldown.remains)
		end
	end
	pausetext:SetText("Pause")
end

function PlantsVsGhouls:InitAll()
	GameStarted = false
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
	for i = 1, 5 do
		self:InitModelSuns(Sun[i].model)
	end
	sodonerowframe:Hide()
	viewtimer = 0
	viewCompleted = 0
	viewCompleted2 = 0.215
	holdtimer = 0
	view:SetScript("OnUpdate", PlantsVsGhouls.ViewOnUpdate)
	animtimer = 0
	animtimer2 = 0
	PlaySoundFile("Interface\\AddOns\\PlantsVsGhouls\\Sounds\\dirt_rise.ogg", "Master")
end

UIParent:HookScript('OnSizeChanged', function(self, width, height)
	UIParentScale = UIParent:GetScale()
	PlantsVsGhouls:InitSunModel()
	PlantsVsGhouls:InitModelSlotX()
	for i = 1, 5 do
		if Ghouls[i].model and Ghouls[i].model.distance then
			Ghouls[i].model.distance = GhoulTypes[Ghouls[i].model.type].distance * UIParentScale * WindowScale
			PlantsVsGhouls:SetOrientation(Ghouls[i].model)
		end
	end
end)

SlashCmdList["PlantsVsGhouls"] = function(msg)
	PlantsVsGhouls:SlashCommands(msg)
end
SLASH_PlantsVsGhouls1 = "/pvg"
SLASH_PlantsVsGhouls2 = "/plantsvsghouls"

function PlantsVsGhouls:SlashCommands(msg)
	if msg == "" then
		sodendcap:SetSize(72 * math.sqrt(2), 72 * math.sqrt(2))
		sodend:SetWidth(60)
		percentCompleted = 0
		if GameStarted == true then
			if frame:IsVisible() then
				self:DisableModes()
				self:ClearCursorTemp()
				self:ClearTemp()
				self:PauseGame()
				frame:Hide()
			else
				frame:Show()
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
					self:InitModelGhouls(Ghouls[i].model, nil, i, true)
				end
				for i = 1, 5 do
					self:InitModelSuns(Sun[i].model)
				end
			end
		else
			if mainframe:IsVisible() then
				self:DisableModes()
				self:ClearCursorTemp()
				self:ClearTemp()
				mainframe:Hide()
			else
				frame:Hide()
				self:InitModelSky()
				mainframe:Show()
			end
		end
	elseif msg == "ui" then
		print(UIParent:GetScale(), UIParentScale)
	end
end

function PlantsVsGhouls:ResizeFrame(frame)
	local Width = frame:GetWidth()
	local Height = frame:GetHeight()
	frame.resizeframeleft = CreateFrame("Frame", nil, frame)
	frame.resizeframeleft:SetFrameStrata("Fullscreen_Dialog")
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
	frame:SetMaxResize(Width * 1.3, Height * 1.3)
	frame:SetMinResize(Width / 1.2, Height / 1.2)
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
			frame.resizeframeleft:Hide()
			frame.resizeframeright:Hide()
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
	frame.resizeframeright:SetFrameStrata("Fullscreen_Dialog")
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
			frame.resizeframeleft:Hide()
			frame.resizeframeright:Hide()
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
			if child ~= frame.resizeframeleft and child ~= frame.resizeframeright and child ~= startframe and child ~= minigamesframe and child ~= puzzleframe and child ~= survivalframe and child ~= optionsframe and child ~= quitframe and child ~= ghoulframe then
				child:SetScale(s)
			end
		end
		gravemask:SetWidth(730 / s)
		gravemask:SetHeight(560 / s)
		dirt:SetWidth(150 / s)
		dirt:SetHeight(32 / s)
		dirt:SetPoint("Bottom", gravemask, "Bottom", - 100 / s, 38 / s)
		flower1:SetWidth(36 / s)
		flower1:SetHeight(47 / s)
		flower1:SetPoint("BottomRight", maskframe, "BottomRight", - 80 / s, 125 / s)
		flower2:SetWidth(43 / s)
		flower2:SetHeight(43 / s)
		flower2:SetPoint("BottomRight", maskframe, "BottomRight", - 120 / s, 125 / s)
		flower3:SetWidth(46 / s)
		flower3:SetHeight(53 / s)
		flower3:SetPoint("BottomRight", maskframe, "BottomRight", - 20 / s, 90 / s)
		self:SetHeight(Height * s)
	end)
end

function PlantsVsGhouls:ResizeLevelFrame(frame)
	local Width = frame:GetWidth()
	local Height = frame:GetHeight()
	frame.resizeframeleft = CreateFrame("Frame", nil, frame)
	frame.resizeframeleft:SetFrameStrata("Fullscreen_Dialog")
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
			frame.resizeframeleft:Hide()
			frame.resizeframeright:Hide()
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
	frame.resizeframeright:SetFrameStrata("Fullscreen_Dialog")
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
			frame.resizeframeleft:Hide()
			frame.resizeframeright:Hide()
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
		WindowScale = s
		frame.scrollframe:SetScale(s)
		local childrens = {self:GetChildren()}
		for _, child in ipairs(childrens) do
			if child ~= frame.resizeframeleft and child ~= frame.resizeframeright and child ~= sunmodel and child ~= modelslotx then
				child:SetScale(s)
			end
		end
		for i = 1, 5 do
			if Ghouls[i].model and Ghouls[i].model.distance then
				Ghouls[i].model.distance = GhoulTypes[Ghouls[i].model.type].distance * UIParentScale * s
				PlantsVsGhouls:SetOrientation(Ghouls[i].model, true)
				Ghouls[i].model:SetPosition(Ghouls[i].model.z / s, 0.7, 0)
			end
		end
		self:SetHeight(Height * s)
	end)
end

PlantsVsGhouls:ResizeFrame(mainframe)
PlantsVsGhouls:ResizeLevelFrame(frame)