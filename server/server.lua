local saveInterval = 1000*60*5

local function savePlayerPositions()
    local file = io.open("playersPos.txt", "w")

    if not file then
        --ERROR LOG
        return
    end

    for _, playerId in ipairs(GetPlayers()) do
        local ped = GetPlayerPed(playerId)
        local x, y, z = table.unpack(GetEntityCoords(ped))
        file:write(string.format("Player %s: x = %f, y = %f, z = %f\n", GetPlayerName(playerId), x, y, z))
    end

    file:close()
end

--Alternatywa w psotaci wysyłki do API
local function sendPlayerPositionsToAPI()
    local playersData = {}

    for _, playerId in ipairs(GetPlayers()) do
        local ped = GetPlayerPed(playerId)
        local x, y, z = table.unpack(GetEntityCoords(ped))
        
        table.insert(playersData, {
            playerId = playerId,
            playerName = GetPlayerName(playerId),
            x = x,
            y = y,
            z = z
        })
    end

    local data = json.encode(playersData)
    local url = "https://myApi.com/api/v1/positions"
    PerformHttpRequest(url, function(statusCode)
        if statusCode == 200 then
            -- SUCCES LOG
        else
            -- FAIL LOG
        end
    end, "POST", data, { ["Content-Type"] = "application/json" })
end

CreateThread(function()
    while true do
        savePlayerPositions()
        sendPlayerPositionsToAPI()
        Wait(saveInterval)
    end
end)


RegisterCommand('powitanie', function(source, args, rawCommand)
    TriggerClientEvent('chat:addMessage', source, {
        color = {255, 150, 250},
        multiline = true,
        args = {"EnjoyRP", "WITAJ NA SERWERZE EnjoyRP"}
    })
end, false)
