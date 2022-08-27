--配置
NBR = NBR or {}
NBR.nb = NBR.nb or {}
NBR.lang = NBR.lang or {}
NBR.general = NBR.general or {}

AddCSLuaFile("config/cl_config.lua")
include("config/sv_config.lua")
-- include("config/cl_config.lua")

--其它脚本
AddCSLuaFile("nextbot/cl_nextbot_controller.lua")
include("nextbot/sv_nextbot_controller.lua")

AddCSLuaFile("lobby/cl_lobby.lua")
include("lobby/sv_lobby.lua")

include("sv_statistics.lua")

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
    PrintMessage(HUD_PRINTTALK, string.format(NBR.lang.ply_connect, name))
end
function GM:PlayerDisconnected(ply)
    PrintMessage(HUD_PRINTTALK, string.format(NBR.lang.ply_disconnect, ply:Nick()))
end

function GM:PlayerInitialSpawn(ply)
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