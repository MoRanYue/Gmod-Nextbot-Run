net.Receive("nbr_openvoidconsole", openVoidOS)

surface.CreateFont("DDBC_Large", {
    font = "DermaDefaultBold",
    size = ScreenScale(13)
    -- weight = 500
})
surface.CreateFont("DDBC_Small", {
    font = "DermaDefaultBold",
    size = ScreenScale(7)
})
surface.CreateFont("HYWH_Large", {
    font = "HYWenHei",
    size = ScreenScale(13)
})
surface.CreateFont("HYWH_Small", {
    font = "HYWenHei",
    size = ScreenScale(7)
})

function openVoidOS()
    -- local frame = vgui.Create("commandPanel")
    local frame = vgui.Create("DFrame")
    frame:SetSize(ScrW(), ScrH())
    frame:Center()
    frame:SetVisible(true)
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)
    frame:SetTitle("")
    frame:MakePopup()
    frame.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, ScrW(), 100, color_black)
        draw.SimpleText(NBR.lang.void_console_title, "HYWH_Large", 30, 20, Color(211,211,211))
        draw.RoundedBox(0, 0, 100, ScrW(), 20, Color(11, 12, 13))
        draw.RoundedBox(0, 0, 120, ScrW(), ScrH() - 120, Color(165, 42, 42))
    end

    local consoleBut = vgui.Create("DButton", frame)
    consoleBut:SetSize(75, 75)
    consoleBut:SetPos(ScrW() - 100, 30)
    consoleBut:SetFont("DDBC_Large")
    consoleBut:SetText("X")
    -- consoleBut:SetColor(Color(255, 12, 13))
    consoleBut:SetTextColor(color_black)
    consoleBut.DoClick = function()
        frame:Close()
    end

    local section_1 = vgui.Create("DPanel", frame)
    section_1:SetPos(60, 160)
    section_1:SetSize(500, 320)
    section_1:SetPaintBackground(false)
    section_1.Paint = function(s, w, h)
        draw.RoundedBox(10, 0, 0, w, h, color_black)
        draw.SimpleText("虚空操作系统", "HYWH_Large", 13, 10, color_white, 0, 0)
        draw.SimpleText("版本：0.11.45.14", "HYWH_Small", 13, ScreenScale(13) + 30, Color(21, 21, 200))
        draw.SimpleText("操作系统类别：Void", "HYWH_Small", 13, ScreenScale(13) + ScreenScale(7) + 30, Color(21, 21, 200))
        draw.SimpleText("已登录用户："..LocalPlayer():Nick(), "HYWH_Small", 13, ScreenScale(13) + ScreenScale(7)*2 + 30, Color(21, 21, 200))
        draw.SimpleText("已登录用户ID："..LocalPlayer():SteamID64(), "HYWH_Small", 13, ScreenScale(13) + ScreenScale(7)*3 + 30, Color(21, 21, 200))
        draw.SimpleText("世界用户数量："..player.GetCount(), "HYWH_Small", 13, ScreenScale(13) + ScreenScale(7)*4 + 30, Color(21, 21, 200))

        draw.RoundedBox(100, 10, ScreenScale(13) + ScreenScale(7)*5 + 50, 50, 50, Color(255, 0, 0))
        draw.RoundedBox(100, 60, ScreenScale(13) + ScreenScale(7)*5 + 50, 50, 50, Color(255, 128, 0))
        draw.RoundedBox(100, 110, ScreenScale(13) + ScreenScale(7)*5 + 50, 50, 50, Color(255, 212, 0))
        draw.RoundedBox(100, 160, ScreenScale(13) + ScreenScale(7)*5 + 50, 50, 50, Color(0, 255, 0))
        draw.RoundedBox(100, 210, ScreenScale(13) + ScreenScale(7)*5 + 50, 50, 50, Color(0, 255, 255))
        draw.RoundedBox(100, 260, ScreenScale(13) + ScreenScale(7)*5 + 50, 50, 50, Color(0, 0, 255))
        draw.RoundedBox(100, 310, ScreenScale(13) + ScreenScale(7)*5 + 50, 50, 50, Color(128, 0, 128))
        -- draw.RoundedBox(100, w/2 - 50, ScreenScale(13) + ScreenScale(7)*5 + 50, 50, 50, Color(166, 166, 166))
    end

    local section_2 = vgui.Create("DPanel", frame)
    -- section_2
end

-- local c_console_text = ""

-- function drawConsole(text, color)
--     c_console_text = c_console_text .. "\n" .. text
--     for k, v in pairs(string.Split(c_console_text, "\n")) do
--         local temp = vgui.Create("DLabel", frame)
--         temp:SetPos(5, 110 + ScreenScale(7) * (tonumber(k) * 1.1))
--         temp:SetFont("DDBC_Small")
--         temp:SizeToContents()
--         temp:SetText(c_console_text)
--         temp:SetTextColor(color)
--         -- draw.SimpleText(v, "DDBC_Large", 5, 110, color)
--     end
-- end