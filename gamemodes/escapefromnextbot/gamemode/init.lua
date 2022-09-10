--配置
NBR = NBR or {}
NBR.nb = NBR.nb or {}
NBR.general = NBR.general or {}
NBR.gui = NBR.gui or {}
NBR.advance = NBR.advance or {}

AddCSLuaFile("config/cl_config.lua")
include("config/sv_config.lua")

--其它脚本
AddCSLuaFile("sh_translate.lua")
include("sh_translate.lua")

AddCSLuaFile("nextbot/cl_nextbot_controller.lua")
include("nextbot/sv_nextbot_controller.lua")

AddCSLuaFile("lobby/cl_lobby.lua")
include("lobby/sv_lobby.lua")

AddCSLuaFile("cl_alivetime.lua")
include("sv_plyalivetime.lua")

include("sv_statistics.lua")
include("sv_voidconsole.lua")

if (NBR.advance.open_tracer) then
    include("sv_tracer.lua")
end

--设置sandbox的一些限制
-- RunConsoleCommand("sbox_noclip", "0")
RunConsoleCommand("sbox_godmode", "0")
RunConsoleCommand("sbox_maxnpcs", tostring(NBR.nb.practical_maxnpcs + 1))
-- RunConsoleCommand("sbox_")

--vgui
-- AddCSLuaFile("vgui/d_nextbot_info.lua")
AddCSLuaFile("vgui/custom_panel/command.lua")
AddCSLuaFile("vgui/custom_elements/statistics_info.lua")

AddCSLuaFile("vgui/d_hud.lua")
AddCSLuaFile("vgui/p_void_nextbot_os.lua")
AddCSLuaFile("vgui/p_statistics_menu.lua")
AddCSLuaFile("vgui/d_scoreboard.lua")

--玩家类
AddCSLuaFile("player_class/player_nbr.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

-- if not file.Exists("efn_loadout.json", "DATA") then file.Write("efn_loadout.json", "[\"weapon_crowbar\",\"weapon_parkour\"]") end
if not file.Exists("efn_loadout.json", "DATA") then file.Write("efn_loadout.json", "[]") end

--玩家
local ply = FindMetaTable("Player")
function ply:GiveLoadout()
    local plyLoadout = NBR.general.start_loadout
    table.Merge(plyLoadout, util.JSONToTable(file.Read("efn_loadout.json", "DATA")))
    for k, v in pairs(plyLoadout) do
        self:Give(v)
    end
end

include("shared.lua")

function GM:PlayerConnect(name, ip)
    for k, v in pairs(player.GetAll()) do
        v:PrintMessage(HUD_PRINTTALK, translate.ClientFormat(v, "notify_player_connect", name))
    end
end
function GM:PlayerDisconnected(ply)
    for k, v in pairs(player.GetAll()) do
        v:PrintMessage(HUD_PRINTTALK, translate.ClientFormat(v, "notify_player_disconnet", ply:Nick()))
    end

    if (player.GetCount() == 0) then
        cleanNextbot()
    end
end

function GM:OnReloaded()
    cleanNextbot()
end

function GM:PreCleanupMap()
    cleanNextbot()
end

function GM:PlayerInitialSpawn(ply)
    for k, v in pairs(player.GetAll()) do
        v:PrintMessage(HUD_PRINTTALK, translate.ClientFormat(v, "notify_player_loaded", ply:Nick()))
    end
    
    --allow player use the flashlight
    ply:AllowFlashlight(true)
end

function GM:PlayerSpawn(ply)
    --设置玩家类
    player_manager.SetPlayerClass(ply, "player_nbr")

    ply:SetGravity(.80)
    ply:SetMaxHealth(100)
    ply:SetRunSpeed(420)
    ply:SetWalkSpeed(300)

    --设置模型
    local mdl = player_manager.TranslatePlayerModel(ply:GetInfo("cl_playermodel"))
    ply:SetModel(mdl)

    ply:SetupHands()

    -- ply:SetNWBool("JustSpawned", true)
    ply:GodEnable()

    timer.Simple(NBR.general.ply_god_time, function() 
        ply:GodDisable()
    end)
end

-- hook.Add("PlayerShouldTakeDamage", "efn_dontKillPlyOnSpawn", function(ply, atk) 
    
-- end)

--只允许管理员开启noclip
function GM:PlayerNoClip(ply, ns)
    if (ns) then
        if (ply:IsAdmin()) then
            return true
        else
            ply:PrintMessage(HUD_PRINTTALK, translate.ClientGet(ply, "notify_dont_in_noclip"))
            return false
        end
    else
        return true
    end
end

hook.Add("PostPlayerDeath", "efn_set_death_var", function(ply)
    ply:SetNWBool("efn_is_dead", true)
end)
hook.Add("PlayerSpawn", "efn_set_alive_var", function(ply)
    ply:SetNWBool("efn_is_dead", false)
end)