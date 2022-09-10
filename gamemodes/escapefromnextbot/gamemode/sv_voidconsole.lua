util.AddNetworkString("efn_openvoidconsole")

hook.Add("KeyPress", "efn_open_void_console", function(ply, key)
    if (key == NBR.advance.void_console_key) then
        -- print("INZOOM")
        net.Start("efn_openvoidconsole")
        net.Send(ply)
    end
end)

concommand.Add("nbr_openvc", function(ply, cmd, arg, argstr)
    -- print(string.format("%s 正在尝试打开虚空控制台！", ply:Nick()))
    net.Start("efn_openvoidconsole")
    net.Send(ply)
end, "Open the Void Console.")