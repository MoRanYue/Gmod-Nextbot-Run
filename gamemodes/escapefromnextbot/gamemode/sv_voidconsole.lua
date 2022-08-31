util.AddNetworkString("nbr_openvoidconsole")

concommand.Add("nbr_openvc", function(ply, cmd, arg, argstr)
    print(string.format("%s 正在尝试打开虚空控制台！", ply:Nick()))
    net.Start("nbr_openvoidconsole")
    net.Send(ply)
end, "Open the Void Console.")