local plymeta = FindMetaTable("Player")

--生存时间
hook.Add("PlayerDeath", "efn_resetalivetime", function(ply, inf, atk)
    ply:SetNWInt("efn_start_alivetime", CurTime())
end)
hook.Add("PlayerSpawn", "efn_spawnalivetime", function(ply)
    ply:SetNWInt("efn_start_alivetime", CurTime())
end)
hook.Add("PlayerInitialSpawn", "efn_initalivetime", function(ply)
    if (!ply:GetNWInt("efn_start_alivetime")) then
        ply:SetNWInt("efn_start_alivetime", CurTime())
    end
end)
-- hook.Add("Tick", "efn_updatealivetime", function()
--     for _, v in pairs(player.GetHumans()) do
--         if (v:Alive()) then
--             v:SetAliveTime(v:GetAliveTime() + 1)
--             -- print(math.floor((v:GetAliveTime() * engine.TickInterval()) / 2))
--         end
--     end
-- end)
----通过math.floor((ply:GetAliveTime() * engine.TickInterval()) / 2)获取秒数

function plymeta:getAliveTime()
    return CurTime() - self:GetNWInt("efn_start_alivetime")
end

function getAllAliveTime()
    local temp = temp or {}
    for _, v in pairs(player.GetAll()) do
        table.insert(temp, v:getAliveTime())
    end
    return temp
end

util.AddNetworkString("alivetime")
util.AddNetworkString("req_alivetime")
util.AddNetworkString("allalivetime")
util.AddNetworkString("req_allalivetime")

net.Receive("req_alivetime", function(len, ply)
    net.Start("alivetime")
        net.WriteInt(ply:getAliveTime(), 32)
    net.Send(ply)
end)

net.Receive("req_allalivetime", function(len, ply)
    net.Start("allalivetime")
        local allalivetime = getAllAliveTime()
        local compress_data = util.Compress(util.TableToJSON(allalivetime))
        local bytes = #compress_data
        net.WriteUInt(bytes, 32)
        net.WriteData(compress_data, bytes)
    net.Send(ply)
end)