DeriveGamemode("sandbox")

--配置
NBR = NBR or {}
NBR.nb = NBR.nb or {}
NBR.lang = NBR.lang or {}
NBR.general = NBR.general or {}

include("config/cl_config.lua")

include("player_class/player_nbr.lua")

GM.Name = "逃离Nextbot / Nextbot Run"
GM.Author = "XXX"
GM.Email = "114514@1918810.com"
GM.Website = "1918810.com"

--翻译
-- include("sh_translate.lua")
-- include("plyclasses")
-- --发送玩家类
-- for i, filename in pairs(file.Find(GM.FolderName.."/gamemode/plyclasses/*.lua", "LUA")) do
-- 	include("plyclasses/"..filename)
-- end

--初始化
function GM:Initialize()
	-- Do stuff
	self.BaseClass.Initialize(self)
	-- self.BaseClass.Initialize()
end