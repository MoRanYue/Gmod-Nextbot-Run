if not file.Exists("efn_nextbot.json", "DATA") then file.Write("efn_nextbot.json", "[]") end

local nbCount = 0
local nbMax = NBR.nb.maxnpcs
local nextbotStatus = 0
local players = player.GetAll()

--计时器
local t = 0
local interval = NBR.nb.refresh_nb_interval
-- local isSpawning = false

--nb Config
local spawnPos = Vector(0, 0, 0)
if (NBR.nb.spawnpos[game:GetMap()]) then
    spawnPos = NBR.nb.spawnpos[game:GetMap()]
else
    spawnPos = ents.FindByClass("info_player_start")[math.random(#ents.FindByClass("info_player_start"))]:GetPos()
end
local spawnNb = table.Add(NBR.nb.nextbot, util.JSONToTable(file.Read("efn_nextbot.json", "DATA")))

util.AddNetworkString("nbInfo")
util.AddNetworkString("req_nbInfo")

hook.Add("OnNPCKilled", "updNbInfoOnPlyRemove", function(npc, atk, int)
    if (npc:IsValid()) then
        if (npc:IsNextBot()) then
            nbCount = nbCount - 1
        end
    end
end)

function spawnNextbot(count, isadmin)
    local expectVal = count + nbCount

    --It's no use now.
    -- if (!spawnPos[game:GetMap()]) then
    --     for k, v in pairs(players) do
    --         v:ChatPrint(string.format(NBR.lang.missing_spawn_pos, game:GetMap()))
    --     end
    --     print(string.format(NBR.lang.missing_spawn_pos, game:GetMap()))

    --     return false
    -- end
    
    if (#spawnNb == 0) then
        for k, v in pairs(players) do
            v:PrintMessage(HUD_PRINTTALK, translate.ClientGet(v, "server_missing_spawn_nb"))
        end
        print(translate.Get("server_missing_spawn_nb"))

        return false
    end

    --生成nextbot
    if (!isadmin) then 
        if (expectVal <= nbMax) then
            nextbotStatus = 1
            --随机抽取
            local temp = 0
            --生成Nextbot
            for i = 1, count do
                temp = ents.Create(spawnNb[math.random(#spawnNb)])
                temp:SetPos(spawnPos)
                temp:Spawn()
                nbCount = nbCount + 1
            end

            updateClientNextbotNum()

            return true
        else 
            return false
        end
    else 
        if (expectVal <= NBR.nb.practical_maxnpcs) then
            nextbotStatus = 1
            --随机抽取
            local temp = 0
            --生成Nextbot
            for i = 1, count do
                temp = ents.Create(spawnNb[math.random(#spawnNb)])
                temp:SetPos(spawnPos)
                temp:Spawn()
                nbCount = nbCount + 1
            end

            updateClientNextbotNum()

            return true
        else 
            return false
        end
    end
end

function cleanNextbot()
    --清除Nextbot语句块
    --clean
    for k, v in pairs(ents:GetAll()) do
        if (v:IsNextBot()) then
            v:Remove()
        end
    end

    nbCount = 0
    nextbotStatus = 0
    updateClientNextbotNum()
end

hook.Add("Think", "nbThink", function()
    if (nextbotStatus == 0) then
        if t < CurTime() then
            t = CurTime() + interval

            cleanNextbot()
            timer.Simple(10, function()
                math.randomseed(tostring(CurTime()):reverse():sub(1, 6))
                spawnNextbot(math.random(1, nbMax), false)
            end)
        end
    end
end)

function updateClientNextbotNum()
    net.Start("nbInfo")
        net.WriteInt(nbCount, 9)
        net.WriteInt(nbMax, 9)
        net.WriteInt(nextbotStatus, 9)
    net.Broadcast()
end

hook.Add( "PlayerSay", "show_nextbotinfo", function( ply, text )
    if (string.lower(text) == "!nbinfo" || string.lower(text) == "/nbinfo") then
        -- ply:PrintMessage(HUD_PRINTTALK, translate.ClientFormat(ply))
	    ply:PrintMessage(HUD_PRINTTALK, translate.ClientFormat(ply, "chatcommand_get_nbinfo", nbCount, nbMax, nextbotStatus))
        return ""
    elseif ((string.lower(text) == "!cleannb" || string.lower(text) == "/cleannb") && ply:IsAdmin()) then
        cleanNextbot()
        for k, v in pairs(player.GetAll()) do
            v:PrintMessage(HUD_PRINTTALK, translate.ClientFormat(v, "notify_admin_clean_nb", ply:Nick()))
        end
    elseif ((string.lower(string.Split(text, " ")[1]) == "!spawnnb" || string.lower(string.Split(text, " ")[1]) == "/spawnnb") && ply:IsAdmin()) then
        spawnNextbot(tonumber(string.Split(text, " ")[2]), true)
        for k, v in pairs(player.GetAll()) do
            v:PrintMessage(HUD_PRINTTALK, translate.ClientFormat(v, "notify_admin_spawn_nb", ply:Nick(), tonumber(string.Split(text, " ")[2])))
        end
    elseif (string.lower(text) == "!helpnb" || string.lower(text) == "/helpnb") then
        ply:PrintMessage(HUD_PRINTTALK, translate.ClientGet(ply, "chatcommand_help"))
    end
end )

net.Receive("req_nbInfo", function(len, ply)
    net.Start("nbInfo")
        net.WriteInt(nbCount, 9)
        net.WriteInt(nbMax, 9)
        net.WriteInt(nextbotStatus, 9)
    net.Send(ply)
end)