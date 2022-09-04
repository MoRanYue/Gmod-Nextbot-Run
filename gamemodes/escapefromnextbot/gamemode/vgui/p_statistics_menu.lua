local nbKillCount = {}
-- local nbStatBar = {}

net.Receive("statisticsInfo", function(len)
    local bytes = net.ReadUInt(32)
    nbKillCount = util.JSONToTable(util.Decompress(net.ReadData(bytes)))
    print("Client Statistics Info Refreshed.")

    print(util.TableToJSON(nbKillCount))
end)



net.Receive("openSMenu", function(len)
    --请求数据
    net.Start("req_stat")
    net.SendToServer()

    local menu = vgui.Create("DFrame")
    menu:SetSize(550, 600)
    menu:SetPos(ScrW()/2 - 500/2, ScrH()/2 - 500/2)
    menu:SetTitle(translate.Get("text_statistics"))
    menu:SetDraggable(true)
    menu:ShowCloseButton(true)
    menu:MakePopup()

    local panel = vgui.Create("DPanel", menu)
    panel:SetSize(menu:GetWide() - 10, menu:GetTall() - 30)
    panel:SetPos(5, 25)

    local scroll = vgui.Create("DScrollPanel", panel)
    scroll:SetSize(panel:GetWide(), panel:GetTall())

    local list = vgui.Create("DListLayout", scroll)
    list:SetSize(scroll:GetWide(), scroll:GetTall())

    local listHeader = vgui.Create("DPanel", list)
    listHeader:SetSize(list:GetWide(), 20)
    listHeader:SetPos(0, 0)
    listHeader.Paint = function()
        draw.RoundedBox(0, 0, 0, listHeader:GetWide(), listHeader:GetTall(), Color(50, 50, 50))
        draw.RoundedBox(0, 0, 14, listHeader:GetWide(), 1, Color(199, 100, 255))

        draw.SimpleText(translate.Get("text_nb_class_name"), "DermaDefault", 4, 0, Color(255, 166, 20), 0, 0)
        draw.SimpleText(translate.Get("text_nb_kill_count"), "DermaDefault", 300, 0, Color(211, 266, 30), 0, 0)
    end
    -- for k, v in pairs(ents.GetAll()) do
    --     if (v:IsNextBot()) then
    --         local nbPanel = vgui.Create("DPanel", list)
    --         nbPanel:SetSize(list:GetWide(), 15)
    --         nbPanel:SetPos(0, 0)
    --         nbPanel.Paint = function()
    --             draw.RoundedBox(0, 0, 0, nbPanel:GetWide(), nbPanel:GetTall(), color_green)
    --             draw.RoundedBox(0, 0, 14, nbPanel:GetWide(), 2, Color(200, 200, 200))

    --             draw.SimpleText(v:GetClass(), "DermaDefault", 4, 0, Color(20, 20, 20), 0, 0)
    --             draw.SimpleText(v:GetNWInt("kill_count"), "DermaDefault", 100, 0, Color(30, 30, 30), 0, 0)
    --         end
    --     end
    -- end
    for k, v in pairs(nbKillCount) do
        local nbPanel = vgui.Create("DPanel", list)
        nbPanel:SetSize(list:GetWide(), 15)
        nbPanel:SetPos(0, 0)
        nbPanel.Paint = function(s, w, h)
            draw.RoundedBox(0, 0, 0, nbPanel:GetWide(), nbPanel:GetTall(), color_green)
            draw.RoundedBox(0, 0, 14, nbPanel:GetWide(), 2, Color(200, 200, 200))

            draw.SimpleText(k, "DermaDefault", 4, 0, Color(20, 20, 20), 0, 0)
            draw.SimpleText(v, "DermaDefault", 300, 0, Color(30, 30, 30), 0, 0)
        end
        -- print(nbStatBar[k]:GetPos())
    end
end)

-- local frame = vgui.Create("DFrame")