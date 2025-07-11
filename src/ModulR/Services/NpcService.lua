--|| ModulR ||--
local ModulR = require(game.ReplicatedStorage.ModulR)

--|| Dependencies ||--
local ModulRInterfaces = require(script.Parent.Parent.Interfaces)

--|| Module ||--
local NpcService: ModulRInterfaces.Service = {
	Client = {},
	Server = {},
	Shared = {},
}

local npcs = game.Workspace:WaitForChild("Npcs", 10):GetChildren() -- Wait for the NPCs folder to load

-- Local functions

-- Init (qui va être supprimé lors de l'init du core)
function NpcService:Initialize()
	ModulR:GetEventBus():Broadcast("NpcServiceInit")
	return self
end

function NpcService:Destroy()
	print("[NpcService] - NpcService destroyed.")
end

return NpcService
