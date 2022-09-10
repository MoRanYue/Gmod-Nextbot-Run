DeriveGamemode("sandbox")

--配置
include("config/cl_config.lua")
-- include("sh_translate.lua")

include("player_class/player_nbr.lua")

GM.Name = "逃离贴图怪 | Escape From Nextbot"
GM.Author = "墨染月"
GM.Email = "2627706725@qq.com"

--初始化
function GM:Initialize()
	-- Do stuff
	self.BaseClass.Initialize(self)
	
	print("!^*^*^*^*^*^*^*^*^*^*^*^*^*^*!")
	print("!     Escape From Nextbot    !")
	-- print("-         逃离Nextbot        !")
	print("!                            !")
	print("!     Created by MoRanYue    !")
	print("!                            !")
	print(" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ")
end