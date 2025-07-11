local ModulR = require(game.ReplicatedStorage.ModulR)

ModulR:AddService("LoggerService", require(game.ReplicatedStorage.ModulR.Services.LoggerService))
ModulR:AddService("DialogueService", require(game.ReplicatedStorage.ModulR.Services.DialogueService))
ModulR:Initialize()


local loggerService = ModulR:GetService("LoggerService")
local dialogueService = ModulR:GetService("DialogueService")

loggerService:ForceLog("This is a shared log message.")
dialogueService:GetDialogue("WelcomeNpc")
