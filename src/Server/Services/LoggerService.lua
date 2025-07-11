--|| ModulR ||--
local ModulR = require(game.ReplicatedStorage.ModulR)

--|| Dependencies ||--
local ModulRInterfaces = require(game.ReplicatedStorage.ModulR.Interfaces)

--|| Module ||--
local LoggerService: ModulRInterfaces.Service = {}

function LoggerService:Initialize()
    ModulR:GetEventBus():Subscribe("LoggerServiceInit", self, function()
        print("[LoggerService] - LoggerServiceInit event received.")
    end)
    ModulR:GetEventBus():Subscribe("TestServiceInit", self, function()
        print("[LoggerService] - TestServiceInit event received.")
    end)
    ModulR:GetEventBus():Broadcast("LoggerServiceInit")
    return self
end

function LoggerService:ForceLog(message: string)
    print("[LoggerService] - " .. message)
end

function LoggerService:Destroy()
    -- Cleanup logic if needed
    print("LoggerService is being destroyed.")
end

return LoggerService
