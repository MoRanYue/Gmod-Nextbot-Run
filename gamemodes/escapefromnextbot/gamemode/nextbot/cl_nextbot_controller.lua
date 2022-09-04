nbCount = 0
nbMax = 0
nbStatus = 0

net.Receive("nbInfo", function(len)
    nbCount = net.ReadInt(9)
    nbMax = net.ReadInt(9)
    nbStatus = net.ReadInt(9)
end)