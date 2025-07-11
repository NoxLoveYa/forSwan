--|| ModulR ||--
local ModulR = require(game.ReplicatedStorage.ModulR)

--|| Dependencies ||--
local ModulRInterfaces = require(script.Parent.Parent.Interfaces)
local DialogueService = ModulR:GetService("DialogueService")
local Players = game:GetService("Players")

--|| Module ||--
local NpcService: ModulRInterfaces.Service = {
	Client = {},
	Server = {},
	Shared = {},
}

local npcs = game.Workspace:WaitForChild("Npcs", 10):GetChildren() -- Wait for the NPCs folder to load
local currentDialogue = nil
local connections = {}

-- Local functions
local function yap(text, textLabel)
	task.spawn(function()
		textLabel.Text = ""
		for i = 1, #text do
			textLabel.Text = textLabel.Text .. text:sub(i, i)
			task.wait(0.02) -- Adjust the speed of the typing effect
		end
	end)
end

-- Init (qui va être supprimé lors de l'init du core)
function NpcService:Initialize()
	ModulR:GetEventBus():Broadcast("NpcServiceInit")
	Players.LocalPlayer.CharacterAdded:Connect(function(character)
		for _, npc in ipairs(npcs) do
			local ChoiceGui: BillboardGui = npc:FindFirstChild("WelcomeNpc"):Clone()
			if not ChoiceGui then
				warn("[NpcService] - ChoiceGui not found for NPC:", npc.Name)
				continue
			end
			local YapGui: BillboardGui = npc:FindFirstChild("YapGui")
			if not YapGui then
				warn("[NpcService] - YapGui not found for NPC:", npc.Name)
				continue
			end

			-- Initialize the NPC's dialogue choice GUI
			local currentDialogue = DialogueService:GetDialogue(npc.Name)
			if not currentDialogue then
				warn("[NpcService] - No dialogue found for NPC:", npc.Name)
				continue
			end

			local choiceIndex = 1
			for choiceText, choiceData in pairs(currentDialogue) do
				local choiceButton = ChoiceGui:FindFirstChild("Button" .. choiceIndex)
				if not choiceButton then
					warn("[NpcService] - Choice button not found for choice index:", choiceIndex)
					return
				end
				choiceButton.Text = choiceText
				choiceButton.Visible = true

				table.insert(connections, choiceButton.MouseButton1Click:Connect(function()
					yap(choiceData.Text, YapGui.TextLabel)
				end))

				choiceIndex += 1
			end

			ChoiceGui.Parent = Players.LocalPlayer.PlayerGui
			ChoiceGui.Adornee = npc.HumanoidRootPart -- Set the Adornee to the NPC model
			ChoiceGui.Enabled = true -- Enable the GUI
		end
	end)

	return self
end

function NpcService:Destroy()
	print("[NpcService] - NpcService destroyed.")
end

return NpcService
