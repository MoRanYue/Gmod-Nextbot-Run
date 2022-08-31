--配置
NBR = NBR or {}
NBR.nb = NBR.nb or {}
NBR.lang = NBR.lang or {}
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

include("sv_statistics.lua")
include("sv_voidconsole.lua")

--设置sandbox的一些限制
-- RunConsoleCommand("sbox_noclip", "0")
RunConsoleCommand("sbox_godmode", "0")
RunConsoleCommand("sbox_maxnpcs", tostring(NBR.nb.practical_maxnpcs + 1))

--vgui
-- AddCSLuaFile("vgui/d_nextbot_info.lua")
AddCSLuaFile("vgui/custom_panel/command.lua")
AddCSLuaFile("vgui/custom_elements/statistics_info.lua")

AddCSLuaFile("vgui/d_hud.lua")
AddCSLuaFile("vgui/p_void_nextbot_os.lua")
AddCSLuaFile("vgui/p_statistics_menu.lua")

--玩家类
AddCSLuaFile("player_class/player_nbr.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

--玩家
local ply = FindMetaTable("Player")
function ply:GiveLoadout()
    for k, v in pairs(NBR.general.start_loadout) do
        self:Give(v)
    end
end

-- include("nextbot/sv_nextbot_controller.lua")

include("shared.lua")

function GM:PlayerConnect(name, ip)
    for k, v in pairs(player.GetAll()) do
        v:PrintMessage(HUD_PRINTTALK, translate.ClientFormat(v, "notify_player_connect", ply:Nick()))
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
    -- PrintMessage(HUD_PRINTTALK, string.format(NBR.lang.ply_loaded, ply:Nick()))
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
end

--只允许管理员开启noclip
function GM:PlayerNoClip(ply, ns)
    if (ns) then
        if (ply:IsAdmin()) then
            return true
        else
            ply:PrintMessage(HUD_PRINTTALK, translate.ClientGet(ply, "notify_dont_in_noclip"))
            return false
        end
    end
end