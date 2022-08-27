local nbCount = 0
local nbMax = 0
local nbStatus = 0

net.Receive("nbInfo", function(len)
    -- include("d_nextbot_info.lua")
    print("aaaaaaaa  "..net.ReadInt(9).." "..net.ReadInt(9).." "..net.ReadInt(9))
    nbCount = net.ReadInt(9)
    nbMax = net.ReadInt(9)
    nbStatus = net.ReadInt(9)
    print("Received the NBINFO in CL_Lua")
    -- include("d_nextbot_info.lua")
    -- changeNbInfo(nbCount, nbMax)
    --translate
    print("Client Info Refresh Finish!")
end)

function updateNbInfo()
    getNbInfo()
    
end

-- function getNbInfo()
--     return {nbCount, nbMax}
-- end