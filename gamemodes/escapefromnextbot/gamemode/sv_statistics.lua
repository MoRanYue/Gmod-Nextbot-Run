-- 记录每个nextbot的击杀次数
local nbKillCount = {}

util.AddNetworkString("statisticsInfo")
util.AddNetworkString("req_stat")
util.AddNetworkString("openSMenu")

net.Receive("req_stat", function(len, ply)
    net.Start("statisticsInfo")
        local compressed_message = util.Compress(util.TableToJSON(nbKillCount))
        local bytes = #compressed_message
        net.WriteUInt(bytes, 32)
        net.WriteData(compressed_message, bytes)
    net.Send(ply)
end)

function GM:PlayerDeath(victim, inflictor, attacker)
    if (attacker:IsNextBot()) then
        if (!attacker:GetNWInt("kill_count")) then
            attacker:SetNWInt("kill_count", 0)
        end

        attacker:SetNWInt("kill_count", attacker:GetNWInt("kill_count") + 1)

        if (nbKillCount[attacker:GetClass()]) then
            nbKillCount[attacker:GetClass()] = nbKillCount[attacker:GetClass()] + 1
        else 
            nbKillCount[attacker:GetClass()] = 1
        end
        updateClientNbStatistics()
    end
end

function GM:ShowSpare2(ply)
    net.Start("openSMenu")
    net.Send(ply)
end

function updateClientNbStatistics()
    net.Start("statisticsInfo")
        local compressed_message = util.Compress(util.TableToJSON(nbKillCount))
        local bytes = #compressed_message
        net.WriteUInt(bytes, 32)
        net.WriteData(compressed_message, bytes)
    net.Broadcast()
end
