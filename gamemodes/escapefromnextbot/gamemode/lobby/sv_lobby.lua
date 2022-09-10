util.AddNetworkString("open_lobby")

function enterLobby(ply)
    net.Start("open_lobby")
    net.Send(ply)
end

hook.Add("PlayerInitialSpawn", "openPlyLobby", function(ply)
    enterLobby(ply)
end)
hook.Add("PlayerSpawn", "plySpawnInit", function(ply)
    ply:GiveLoadout()
end)