local ModulR = require(game.ReplicatedStorage.ModulR)

ModulR:AddService("LoggerService", require(game.ReplicatedStorage.ModulR.Services.LoggerService))
ModulR:Initialize()


local loggerService = ModulR:GetService("LoggerService")

loggerService:ForceLog("This is a shared log message.")
