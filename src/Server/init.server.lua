local ModulR = require(game.ReplicatedStorage.ModulR)

ModulR:AddService("LoggerService", require(game.ReplicatedStorage.ModulR.Services.LoggerService))
ModulR:AddService("InventoryService", require(game.ReplicatedStorage.ModulR.Services.InventoryService))
ModulR:Initialize()

local loggerService = ModulR:GetService("LoggerService")
local inventoryService = ModulR:GetService("InventoryService")
local Players = game:GetService("Players")

loggerService:ForceLog("This is a shared log message.")
task.wait(3)
for _, player in ipairs(Players:GetPlayers()) do
    loggerService:ForceLog("Player joined: " .. player.Name)
    inventoryService:PrintInventory(player)
    inventoryService:AddItem(player, "sword", 1, "A sharp sword.")
    inventoryService:AddItem(player, "fish")
    inventoryService:PrintInventory(player)
    inventoryService:RemoveItem(player, "sword", 1)
    inventoryService:PrintInventory(player)
end