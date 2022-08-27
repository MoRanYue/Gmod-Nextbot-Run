local nbCount = 0
local nbMax = NBR.nb.maxnpcs
local waveCount = 0
local nextbotStatus = 0
-- local players = FindMetaTable("Player")
local players = player.GetAll()

--计时器
local t = 0
local interval = NBR.nb.refresh_nb_interval
-- local isSpawning = false

--nb Config
local spawnPos = NBR.nb.spawnpos
local spawnNb = NBR.nb.nextbot

util.AddNetworkString("nbInfo")
util.AddNetworkString("req_nbInfo")

-- hook.Add("OnEntityCreated", "updNbInfoOnPlySpawn", function(ent)
--     if (ent:IsValid()) then
--         if (ent:IsNextBot()) then
--             nbCount = nbCount + 1
--         end
--     end
-- end)
hook.Add("OnNPCKilled", "updNbInfoOnPlyRemove", function(npc, atk, int)
    if (npc:IsValid()) then
        if (npc:IsNextBot()) then
            nbCount = nbCount - 1
        end
    end
end)

function spawnNextbot(count, isadmin)
    waveCount = waveCount + 1
    local expectVal = count + nbCount

    if (!spawnPos[game:GetMap()]) then
        for k, v in pairs(players) do
            v:ChatPrint(string.format(NBR.lang.missing_spawn_pos, game:GetMap()))
        end
        print(string.format(NBR.lang.missing_spawn_pos, game:GetMap()))

        return false
    end
    
    if (#spawnNb == 0) then
        for k, v in pairs(players) do
            v:ChatPrint(NBR.lang.missing_spawn_nb)
        end
        print(NBR.lang.missing_spawn_nb)

        return false
    end

    --生成nextbot语句块
    if (!isadmin) then 
        if (expectVal <= nbMax) then
            nextbotStatus = 1
            --随机抽取
            math.randomseed(tostring(CurTime()):reverse():sub(1, 6))

            local temp = 0
            
            --生成Nextbot
            for i = 1, count do
                -- math.randomseed(tostring(CurTime()):reverse():sub(1, 6))
                temp = ents.Create(spawnNb[math.random(#spawnNb)])
                temp:SetPos(spawnPos[game.GetMap()])
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
            math.randomseed(tostring(CurTime()):reverse():sub(1, 6))

            local temp = 0

            --生成Nextbot
            for i = 1, count do
                -- math.randomseed(tostring(CurTime()):reverse():sub(1, 6))
                print(math.random(#spawnNb))
                temp = ents.Create(spawnNb[math.random(#spawnNb)])
                --随机偏移生成位置，防止卡住
                -- temp:SetPos(spawnPos[game.GetMap()] + Vector:Random(-2, 2))
                temp:SetPos(spawnPos[game.GetMap()])
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
        --TrAnSlAtEaBlE
	    ply:ChatPrint(string.format(NBR.lang.get_nbinfo, nbCount, nbMax, nextbotStatus))
        return ""
    elseif (string.lower(text) == "!cleannb" || string.lower(text) == "/cleannb" && ply:IsAdmin()) then
        cleanNextbot()
        PrintMessage(HUD_PRINTTALK, string.format(NBR.lang.admin_clean_nb, ply:Nick()))
    elseif (string.lower(string.Split(text, " ")[1]) == "!spawnnb" || string.lower(string.Split(text, " ")[1]) == "/spawnnb" && ply:IsAdmin()) then
        spawnNextbot(tonumber(string.Split(text, " ")[2]), true)
        PrintMessage(HUD_PRINTTALK, string.format(NBR.lang.admin_spawn_nb, ply:Nick(), tonumber(string.Split(text, " ")[2])))
    end
end )

net.Receive("req_nbInfo", function(len, ply)
    net.Start("nbInfo")
        net.WriteInt(nbCount, 9)
        net.WriteInt(nbMax, 9)
        net.WriteInt(nextbotStatus, 9)
    net.Send(ply)
end)