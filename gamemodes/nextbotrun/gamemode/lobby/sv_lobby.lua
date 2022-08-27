util.AddNetworkString("open_lobby")
-- util.AddNetworkString("start_game")

function enterLobby(ply)
    net.Start("open_lobby")
    net.Send(ply)
end

net.Receive("start_game", function(len, ply)
    updateClientNextbotNum()
    ply:GiveLoadout()
end)

hook.Add("PlayerInitialSpawn", "openPlyLobby", function(ply)
    enterLobby(ply)
end)
hook.Add("PlayerSpawn", "plySpawnInit", function(ply)
    ply:GiveLoadout()
end)