local ModulR = require(game.ReplicatedStorage.ModulR)

ModulR:AddService("LoggerService", require(script.Parent.Services.LoggerService))
ModulR:AddService("TestService", require((script.Parent.Services.TestService)))
ModulR:Initialize()


local loggerService = ModulR:GetService("LoggerService")
local testService = ModulR:GetService("TestService")


loggerService:ForceLog("This is a test log message from the LoggerService.")
testService:TestMethod()
