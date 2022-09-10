net.Receive("efn_openvoidconsole", openVoidOS)

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
        draw.SimpleText("虚空 - 控制台", "HYWH_Large", 30, 20, Color(211,211,211))
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

        --绘制七色圆圈
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
    section_2:SetPos(650, 160)
    section_2:SetSize(700, 420)
    section_2:SetPaintBackground(false)
    section_2.Paint = function(s, w, h)
        draw.RoundedBox(10, 0, 0, w, h, Color(40, 40, 30))

        draw.SimpleText("用户", "HYWH_Large", 20, 10, color_white, 0, 0)
    end

    local section_2_scroll = vgui.Create("DScrollPanel", section_2)
    section_2_scroll:SetPos(0, ScreenScale(13) + 50)
    section_2_scroll:SetSize(section_2:GetWide(), section_2:GetTall() - ScreenScale(13) + 50)
    section_2_scroll.Paint = function(s, w, h)
        draw.RoundedBox(10, 0, 0, w, h , Color(123, 123, 123))
    end

    local section_2_scroll_list = vgui.Create("DListLayout", section_2_scroll)
    section_2_scroll_list:SetPos(5, 5)
    section_2_scroll_list:SetSize(section_2_scroll:GetWide() - 10, section_2_scroll:GetTall() - 10)

    for _, v in pairs(player.GetAll()) do
        local temp = vgui.Create("DPanel", section_2_scroll_list)
        temp:SetPos(0, 0)
        temp:SetSize(section_2_scroll_list:GetWide(), 40)
        temp.Paint = function(s, w, h)
            draw.RoundedBox(10, 0, 0, section_2_scroll_list:GetWide(), 30, Color(100, 100, 0))

            draw.SimpleText(v:Name(), "HYWH_Small", 5, 0, color_black)
            draw.SimpleText(v:SteamID64(), "HYWH_Small", 205, 0, color_black)
        end
    end
end