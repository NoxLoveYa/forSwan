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
			for choiceName, _ in pairs(currentDialogue) do
				local choiceButton: TextButton = ChoiceGui:FindFirstChild("Button" .. choiceIndex)
				if not choiceButton then
					warn(
						"[NpcService] - Choice button not found for NPC:",
						npc.Name,
						"Choice:",
						choiceName,
						"Button" .. choiceIndex
					)
					continue
				end

				choiceButton.Text = choiceName -- Set the text of the choice button
				table.insert(connections, choiceButton.MouseButton1Click:Connect(function()
					currentDialogue = DialogueService:FollowDialogue(currentDialogue, choiceName)
					task.spawn(function()
						local currentText = ""
						local endText = currentDialogue.Text
						while currentText ~= endText do
							currentText = endText:sub(1, #currentText + 1)
							YapGui.TextLabel.Text = currentText
							task.wait(0.015) -- Adjust the speed of text display
						end
					end)
                    local choiceSave = {}
                    for _, choiceName in pairs(currentDialogue.Choices) do
                        choiceSave[choiceName] = DialogueService:GetSubDialogue(npc.Name, choiceName)
                    end
                    currentDialogue = choiceSave
                    local subDialogueIndex = 1
                    print("Current Dialogue:", currentDialogue)
                    for subChoiceName, _ in pairs(currentDialogue) do
                        local subChoiceButton: TextButton = ChoiceGui:FindFirstChild("Button" .. subDialogueIndex)
                        if not subChoiceButton then
                            warn(
                                "[NpcService] - Sub choice button not found for NPC:",
                                npc.Name,
                                "Sub Choice:",
                                subChoiceName,
                                "Button" .. subDialogueIndex
                            )
                            continue
                        end

                        subChoiceButton.Text = subChoiceName -- Set the text of the sub choice button
                        subChoiceButton.Visible = true -- Make the sub choice button visible
                        subDialogueIndex += 1
                    end
                    for i = subDialogueIndex, 3 do
                        local subChoiceButton: TextButton = ChoiceGui:FindFirstChild("Button" .. i)
                        if subChoiceButton then
                            subChoiceButton.Visible = false -- Hide unused buttons
                        end
                    end
				end))
				choiceIndex += 1
				choiceButton.Visible = true -- Make the choice button visible
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
