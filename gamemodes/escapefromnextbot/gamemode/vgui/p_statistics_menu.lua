local nbKillCount = {}
local nbKillCountIndex = {}
local nbKillCountValue = {}
local nbStatBar = {}

net.Receive("statisticsInfo", function(len)
    local bytes = net.ReadUInt(32)
    nbKillCount = util.JSONToTable(util.Decompress(net.ReadData(bytes)))
    print("Client Statistics Info Refreshed.")
    print(util.TableToJSON(nbKillCount))

    nbKillCountIndex = {}
    nbKillCountValue = {}
    for k, v in pairs(nbKillCount) do
        table.insert(nbKillCountIndex, v)
        table.insert(nbKillCountValue, k)
    end
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
    menu.Paint = function(s, w, h)
        draw.RoundedBox(7, 0, 0, w + 10, h + 10, Color(0, 144, 0))
        draw.RoundedBox(5, 10/2, 25, w - 10, h - 30, color_white)
    end
    menu:MakePopup()

    for k, v in pairs(nbKillCountIndex) do
        nbStatBar[k] = vgui.Create("StatBar", menu)
        nbStatBar[k]:SetPos(8, 27 + 15 * (k - 1))
        nbStatBar[k].Paint = function(s, w, h)
            draw.SimpleText(nbKillCountValue[k], "DermaDefault", 0, 0, color_black, 0, 0)
            draw.SimpleText(v, "DermaDefault", 200, 0, color_black, 0, 0)
        end
        print(nbStatBar[k]:GetPos())
    end
end)

-- local frame = vgui.Create("DFrame")