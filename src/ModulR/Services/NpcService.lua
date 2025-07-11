--|| ModulR ||--
local ModulR = require(game.ReplicatedStorage.ModulR)

--|| Dependencies ||--
local ModulRInterfaces = require(script.Parent.Parent.Interfaces)
local DialogueService = ModulR:GetService("DialogueService")

--|| Module ||--
local NpcService: ModulRInterfaces.Service = {
	Client = {},
	Server = {},
	Shared = {},
}

local npcs = game.Workspace:WaitForChild("Npcs", 10):GetChildren() -- Wait for the NPCs folder to load
local currentDialogue = nil

-- Local functions

-- Init (qui va être supprimé lors de l'init du core)
function NpcService:Initialize()
	ModulR:GetEventBus():Broadcast("NpcServiceInit")
	for _, npc in ipairs(npcs) do
		local proximityPrompt: ProximityPrompt = npc:FindFirstChild("ProximityPrompt")

		if not proximityPrompt then
			warn("[NpcService] - ProximityPrompt not found for NPC:", npc.Name)
		end
        proximityPrompt.Triggered:Connect(function(player)
            local currentDialogue = DialogueService:GetDialogue(npc.Name)
            local currentDialogue = DialogueService:FollowDialogue(currentDialogue, "Presentation")
            task.spawn(function()
                local currentText = ""

                while (#currentText ~= #currentDialogue.Text) do
                    currentText = currentDialogue.Text:sub(1, #currentText + 1)
                    npc.BillboardGui.TextLabel.Text = currentText
                    task.wait(math.random(0.1, 0.2)) -- Adjust the speed of text display
                end
            end)
            ModulR:GetEventBus():Broadcast("NpcInteraction", { Player = player, Npc = npc.Name })
        end)
	end
	return self
end

function NpcService:Destroy()
	print("[NpcService] - NpcService destroyed.")
end

return NpcService
