local nbCount = 0
local nbMax = 0
local nbStatus = 0

net.Receive("nbInfo", function(len)
    nbCount = net.ReadInt(9)
    nbMax = net.ReadInt(9)
    nbStatus = net.ReadInt(9)
    -- print(language.GetPhrase("efn.nb.recive_net_msg"))
end)