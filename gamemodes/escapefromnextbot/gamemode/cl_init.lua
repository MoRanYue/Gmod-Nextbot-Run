--配置
NBR = NBR or {}
NBR.lang = NBR.lang or {}
NBR.gui = NBR.gui or {}

--其它脚本
include("sh_translate.lua")

include("nextbot/cl_nextbot_controller.lua")
include("lobby/cl_lobby.lua")

include("shared.lua")

--vgui
include("vgui/custom_panel/command.lua")
include("vgui/custom_elements/statistics_info.lua")

include("vgui/d_hud.lua")
include("vgui/p_void_nextbot_os.lua")
include("vgui/p_statistics_menu.lua")

--禁止打开道具菜单
--can't open the Prop Menu
function GM:SpawnMenuOpen()
	--管理员可以
	--But admins can
	if (LocalPlayer():IsAdmin()) then
		return true
	end

	return false
end
--禁止用物理枪拾取nextbot
function GM:PhysgunPickup(ply, ent)
	if (ent:IsNextBot()) then
		return false
	end
end

--玩家生成
function GM:PostDrawViewModel( vm, ply, weapon )

	if ( weapon.UseHands || !weapon:IsScripted() ) then

		local hands = LocalPlayer():GetHands()
		if ( IsValid( hands ) ) then hands:DrawModel() end

	end

end