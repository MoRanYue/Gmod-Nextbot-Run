efn_clAliveTime = 0
efn_allAliveTime = efn_allAliveTime or {}

net.Receive("alivetime", function(len)
    efn_clAliveTime = net.ReadInt(32)
end)
net.Receive("allalivetime", function(len)
    local bytes = net.ReadUInt(32)
    local json = net.ReadData(bytes)
    efn_allAliveTime = util.JSONToTable(util.Decompress(json))
end)

function translateTime(time)
    local ret = ""

    local seconds = time
    -- local seconds = math.floor(efn_clAliveTime * engine.TickInterval())

    if (seconds < 60) then
        ret = translate.Format("text_seconds", seconds)
        return ret
    elseif (seconds >= 60 && seconds < 3600) then
        local minutes = math.floor(seconds / 60)
        ret = translate.Format("text_minutes", minutes) .. translate.Format("text_seconds", seconds - 60 * minutes)
        return ret
    else
        local minutes = math.floor(seconds / 60)
        local hours = math.floor(minutes / 60)

        ret = translate.Format("text_hours", hours) .. translate.Format("text_minutes", minutes - 60 * hours) .. translate.Format("text_seconds", seconds - 60 * minutes)
    end
end