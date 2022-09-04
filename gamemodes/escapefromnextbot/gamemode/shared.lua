DeriveGamemode("sandbox")

--配置
include("config/cl_config.lua")
-- include("sh_translate.lua")

include("player_class/player_nbr.lua")

GM.Name = "Escape From Nextbot"
GM.Author = "墨染月"
GM.Email = "2627706725@qq.com"

--初始化
function GM:Initialize()
	-- Do stuff
	self.BaseClass.Initialize(self)
	-- self.BaseClass.Initialize()
end