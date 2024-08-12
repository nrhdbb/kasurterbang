local QBCore = exports['qb-core']:GetCoreObject()
local carpetObject = nil
local ishadikasurterbang = false
local smokeEffect = nil
local starEffect = nil
local fireEffects = {}

local function Createhadikasurterbang()
local playerPed = PlayerPedId()
local playerCoords = GetEntityCoords(playerPed)

local kasurhadiModel = `prop_rub_matress_01`
RequestModel(kasurhadiModel)
while not HasModelLoaded(kasurhadiModel) do
Wait(0)
end

carpetObject = CreateObject(kasurhadiModel, playerCoords.x, playerCoords.y, playerCoords.z - 0.5, true, true, false)
SetEntityCollision(carpetObject, false, false)

RequestAnimDict("rcmepsilonism3")
while not HasAnimDictLoaded("rcmepsilonism3") do
Wait(0)
end
TaskPlayAnim(playerPed, "rcmepsilonism3", "ep_3_rcm_marnie_meditating", 8.0, -8.0, -1, 1, 0, false, false, false)


AttachEntityToEntity(playerPed, carpetObject, 0, 0.0, -0.2, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)

RequestNamedPtfxAsset("core")
while not HasNamedPtfxAssetLoaded("core") do
Wait(0)
end
UseParticleFxAssetNextCall("core")
smokeEffect = StartParticleFxLoopedOnEntity("exp_grd_bzgas_smoke", carpetObject, 0.0, 0.0, -0.5, 0.0, 0.0, 0.0, 2.0, false, false, false)


UseParticleFxAssetNextCall("core")
starEffect = StartParticleFxLoopedOnEntity("ent_amb_stoner_eff_dir", carpetObject, 0.0, -2.0, 1.0, 0.0, 0.0, 0.0, 1.0, false, false, false)

local firePositions = {
    {x = 1.0, y = 1.0, z = 0.0},
    {x = -1.0, y = 1.0, z = 0.0},
    {x = 1.0, y = -1.0, z = 0.0},
    {x = -1.0, y = -1.0, z = 0.0}
}

for _, pos in ipairs(firePositions) do
    UseParticleFxAssetNextCall("core")
    local fire = StartParticleFxLoopedOnEntity("ent_sht_flame", carpetObject, pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 0.5, false, false, false)
    table.insert(fireEffects, fire)
end

ishadikasurterbang = true
end

local function Removehadikasurterbang()
    if carpetObject then
    DeleteObject(carpetObject)
    carpetObject = nil
    end
    
    if smokeEffect then
    StopParticleFxLooped(smokeEffect, 0)
    smokeEffect = nil
    end
    
    if starEffect then
    StopParticleFxLooped(starEffect, 0)
    starEffect = nil
    end
    
    for _, fire in ipairs(fireEffects) do
    StopParticleFxLooped(fire, 0)
    end
    fireEffects = {}
    
    local playerPed = PlayerPedId()
    ClearPedTasks(playerPed)
    DetachEntity(playerPed, true, true)
    
    ishadikasurterbang = false
    end
    
    RegisterCommand("hadiaja", function()
    local Player = QBCore.Functions.GetPlayerData()
    if Player.job.name ~= "admin" then
    QBCore.Functions.Notify("Anda tidak memiliki izin untuk menggunakan fitur ini!", "error")
    return
    end
    
    if ishadikasurterbang then
    Removehadikasurterbang()
    QBCore.Functions.Notify("kasur terbang dinonaktifkan", "success")
    else
    Createhadikasurterbang()
    QBCore.Functions.Notify("kasur terbang diaktifkan", "success")
    end
    end, false)
    Citizen.CreateThread(function()
    while true do
    Citizen.Wait(0)
    if ishadikasurterbang then
    local carpetPos = GetEntityCoords(carpetObject)
    
    DisableControlAction(0, 32, true) 
    DisableControlAction(0, 33, true)
    DisableControlAction(0, 34, true) 
    DisableControlAction(0, 35, true) 
    DisableControlAction(0, 22, true) 
    DisableControlAction(0, 21, true) 
    
    if IsDisabledControlPressed(0, 32) then 
    carpetPos = GetOffsetFromEntityInWorldCoords(carpetObject, 0.0, 0.5, 0.0)
    end
    if IsDisabledControlPressed(0, 33) then 
    carpetPos = GetOffsetFromEntityInWorldCoords(carpetObject, 0.0, -0.5, 0.0)
    end
    if IsDisabledControlPressed(0, 34) then 
    carpetPos = GetOffsetFromEntityInWorldCoords(carpetObject, -0.5, 0.0, 0.0)
    end
    if IsDisabledControlPressed(0, 35) then 
    carpetPos = GetOffsetFromEntityInWorldCoords(carpetObject, 0.5, 0.0, 0.0)
    end
    if IsDisabledControlPressed(0, 22) then 
   
    carpetPos = GetOffsetFromEntityInWorldCoords(carpetObject, 0.0, 0.0, 0.5)
    end
    if IsDisabledControlPressed(0, 21) then 
    carpetPos = GetOffsetFromEntityInWorldCoords(carpetObject, 0.0, 0.0, -0.5)
    end
    
    SetEntityCoords(carpetObject, carpetPos.x, carpetPos.y, carpetPos.z, true, true, true, false)
    end
    end
    end)
