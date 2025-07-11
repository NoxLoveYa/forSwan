--|| ModulR ||--
local ModulR = require(game.ReplicatedStorage.ModulR)

--|| Dependencies ||--
local ModulRInterfaces = require(script.Parent.Parent.Interfaces)

--|| Module ||--
local DialogueService: ModulRInterfaces.Service = {
	Client = {},
	Server = {},
	Shared = {},
}

local Dialogues = {}

-- Local functions
local function loadDialogues()
	local dialogueFolder = game.ReplicatedStorage.Data.Dialogues
	local dialogues = {}

    for _, dialogue in ipairs(dialogueFolder:GetChildren()) do
        if dialogue:IsA("ModuleScript") then
            local dialogueData = require(dialogue)
            dialogues[dialogue.Name] = dialogueData
        end
    end
    return dialogues
end

-- Init (qui va être supprimé lors de l'init du core)
function DialogueService:Initialize()
	Dialogues = loadDialogues()
    print("[DialogueService] - Dialogues loaded:", Dialogues)
	ModulR:GetEventBus():Broadcast("DialogueServiceInit")
	return self
end

function DialogueService:Destroy()
	print("[DialogueService] - DialogueService destroyed.")
end

function DialogueService.Client:GetDialogue(npcName: string)
	-- This function would start a dialogue with the NPC
    print("[DialogueService] - Getting dialogue for NPC:", npcName)
    local dialogue = Dialogues[npcName]
    print("[DialogueService] - Dialogue found:", dialogue)
end

function DialogueService.Client:FollowDialogue(dialogue: {}, choice: string)
    -- This function would handle the player's choice in the dialogue
    print("[DialogueService] - Following dialogue:", dialogue, "Choice:", choice)
    if not dialogue or dialogue.Choices then return nil end

    local nextDialogue = dialogue[choice]
    if not nextDialogue then
        print("[DialogueService] - No next dialogue found for choice:", choice)
        return nil
    end
    print("[DialogueService] - Next dialogue found:", nextDialogue)
    return nextDialogue
end

return DialogueService
