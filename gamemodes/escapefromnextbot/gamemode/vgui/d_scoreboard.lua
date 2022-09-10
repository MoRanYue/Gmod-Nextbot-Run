scoreboard = scoreboard or {}

surface.CreateFont("BM_Large", {
    font = "Tahoma",
    -- size = ScreenScale(15),
    size = 60,
    weight = 500
})
surface.CreateFont("BM_Medium", {
    font = "Tahoma",
    -- size = ScreenScale(10),
    size = 40,
    weight = 500
})
surface.CreateFont("BM_Small", {
    font = "Tahoma",
    -- size = ScreenScale(7),
    size = 28,
    weight = 500
})
surface.CreateFont("HYWH_Large", {
    font = "HYWenHei",
    -- size = ScreenScale(17)
    size = 68
})
surface.CreateFont("HYWH_Small", {
    font = "HYWenHei",
    -- size = ScreenScale(7)
    size = 28
})

function scoreboard:show()
    -- print("sb:show")
    -- net.Start("req_alivetime")
    -- net.SendToServer()
    -- net.Start("req_allalivetime")
    -- net.SendToServer()

    local panel = vgui.Create("DPanel")
    panel:SetSize(1000, 800)
    panel:Center()
    panel:SetPaintBackground(false)
    panel.Paint = function(s, w, h)
        draw.RoundedBox(10, 0, 0, w, h, Color(20, 20, 20, 230))
        draw.RoundedBox(7, 20, h/13, w - 40, 62, Color(4, 4, 0, 200))

        --sysTime
        draw.DrawText(os.date("%H:%M:%S"), "HYWH_Small", 5, 3, color_white, 0)
        --gmText
        draw.DrawText(translate.Get("text_gamemode"), "BM_Small", w/2, 3, color_green, TEXT_ALIGN_CENTER)
        --svTitle
        draw.DrawText(GetHostName(), "HYWH_Large", w/2, h*0.04, color_white, TEXT_ALIGN_CENTER)
        draw.DrawText(GetHostName(), "HYWH_Large", w/2+3, h*0.04+3, color_green, TEXT_ALIGN_CENTER)
        --plyCount
        draw.DrawText(translate.Format("text_ply_count", player.GetCount(), game.MaxPlayers()), "HYWH_Small", w*0.1, h*0.135, color_white, TEXT_ALIGN_CENTER)
        --nbCount
        draw.DrawText(translate.Format("hud_nbinfo_num", nbCount, nbMax), "HYWH_Small", w*0.3, h*0.135, color_white, TEXT_ALIGN_CENTER)
        --deathCount
        draw.DrawText(translate.Format("hud_death_count", LocalPlayer():Deaths()), "HYWH_Small", w*0.52, h*0.135, color_white, TEXT_ALIGN_CENTER)
        --aliveTime
        if (LocalPlayer():Alive()) then
            draw.DrawText(translate.Format("text_ply_alive_time", translateTime(CurTime() - LocalPlayer():GetNWInt("efn_start_alivetime"))), "HYWH_Small", w*0.8, h*0.135, color_white, TEXT_ALIGN_CENTER)
        else
            draw.DrawText(translate.Get("text_sb_ply_dead"), "HYWH_Small", w*0.8, h*0.135, color_white, TEXT_ALIGN_CENTER)
        end
    end

    -- local gmText = vgui.Create("DLabel", panel)
    -- -- gmText:SetPos(10, 3)
    -- gmText:SetFont("BM_Small")
    -- gmText:SetText(translate.Get("text_gamemode"))
    -- gmText:SizeToContents()
    -- gmText:CenterHorizontal()
    -- gmText:SetY(3)

    -- local svTitle = vgui.Create("DLabel", panel)
    -- svTitle:SetFont("HYWH_Large")
    -- svTitle:SetText(GetHostName())
    -- svTitle:SizeToContents()
    -- svTitle:CenterHorizontal()
    -- svTitle:CenterVertical(0.07)
    
    -- local plyCount = vgui.Create("DLabel", panel)
    -- plyCount:SetFont("HYWH_Small")
    -- plyCount:SetText(translate.Format("text_ply_count", player.GetCount(), game.MaxPlayers()))
    -- plyCount:CenterHorizontal(0.1)
    -- plyCount:CenterVertical(0.147)
    -- plyCount:SizeToContents()

    -- local a = tostring(translate.Format("hud_nbinfo_num", nbCount, nbMax))
    -- local nbCount = vgui.Create("DLabel", panel)
    -- nbCount:SetFont("HYWH_Small")
    -- nbCount:SetText(a)
    -- nbCount:CenterHorizontal(0.25)
    -- nbCount:CenterVertical(0.147)
    -- nbCount:SizeToContents()

    -- local deathCount = vgui.Create("DLabel", panel)
    -- deathCount:SetFont("HYWH_Small")
    -- deathCount:SetText(translate.Format("hud_death_count", LocalPlayer():Deaths()))
    -- deathCount:CenterHorizontal(0.5)
    -- deathCount:CenterVertical(0.147)
    -- deathCount:SizeToContents()

    -- local aliveTime = vgui.Create("DLabel", panel)
    -- aliveTime:SetFont("HYWH_Small")
    -- aliveTime:SetText(translate.Format("text_ply_alive_time", translateTime(efn_clAliveTime)))
    -- aliveTime:CenterHorizontal(0.7)
    -- aliveTime:CenterVertical(0.147)
    -- aliveTime:SizeToContents()

    local listBg = vgui.Create("DPanel", panel)
    listBg:SetY(150)
    listBg:SetSize(950, 600)
    listBg:CenterHorizontal()
    listBg.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(175, 62, 62))
    end

    local plyList = vgui.Create("DListLayout", panel)
    plyList:SetY(150)
    plyList:SetSize(950, 600)
    plyList:CenterHorizontal()

    local listHeader = vgui.Create("DPanel", plyList)
    listHeader:SetSize(plyList:GetWide(), 38)
    listHeader:SetPos(0, 0)
    listHeader.Paint = function()
        draw.RoundedBox(0, 0, 0, listHeader:GetWide(), listHeader:GetTall(), Color(50, 50, 50))
        -- draw.RoundedBox(0, 0, 14, listHeader:GetWide(), 1, Color(199, 100, 255))

        draw.SimpleText(translate.Get("text_sb_ply_num"), "BM_Small", 2, 0, Color(255, 266, 30), 0, 0)
        draw.SimpleText(translate.Get("text_sb_ply_name"), "BM_Small", 100, 0, Color(255, 266, 30), 0, 0)
        draw.SimpleText(translate.Get("text_sb_ply_user_group"), "BM_Small", 300, 0, Color(255, 266, 30), 0, 0)
        draw.SimpleText(translate.Get("text_sb_ply_death"), "BM_Small", 450, 0, Color(255, 266, 30), 0, 0)
        draw.SimpleText(translate.Get("text_sb_ply_alive_time"), "BM_Small", 570, 0, Color(255, 266, 30), 0, 0)
        draw.SimpleText(translate.Get("text_sb_ply_ping"), "BM_Small", 850, 0, Color(255, 266, 30), 0, 0)
    end

    for k, v in pairs(player.GetAll()) do
        local plyPanel = vgui.Create("DPanel", plyList)
        plyPanel:SetPos(0, 0)
        plyPanel:SetSize(plyList:GetWide(), 30)
        plyPanel.Paint = function()
            draw.RoundedBox(0, 0, 0, listHeader:GetWide(), listHeader:GetTall(), Color(190, 141, 141))
            draw.RoundedBox(0, 0, 29, listHeader:GetWide(), 2, Color(100, 50, 50))

            draw.SimpleText(k, "BM_Small", 2, 0, Color(255, 200, 255))
            draw.SimpleText(v:Name(), "BM_Small", 100, 0, Color(255, 200, 255))
            draw.SimpleText(v:GetUserGroup(), "BM_Small", 300, 0, Color(255, 200, 255))
            draw.SimpleText(v:Deaths(), "BM_Small", 450, 0, Color(255, 12, 11))
            if (!v:GetNWBool("efn_is_dead")) then
                draw.SimpleText(translateTime(CurTime() - v:GetNWInt("efn_start_alivetime")), "BM_Small", 570, 0, Color(255, 200, 255))
            else
                draw.SimpleText(translate.Get("text_sb_ply_dead"), "BM_Small", 570, 0, Color(255, 29, 26))
            end
            draw.SimpleText(v:Ping(), "BM_Small", 850, 0, Color(255, 0, 255))
        end
    end

    -- local plylist = vgui.Create("DListView", panel)
    -- plylist:SetY(150)
    -- plylist:SetSize(950, 600)
    -- -- print(panel:GetSize())
    -- plylist:CenterHorizontal()
    -- plylist:SetHeaderHeight(ScreenScale(7) + 10)
    -- plylist:SetDataHeight(ScreenScale(7))
    -- plylist.Paint = function(s, w, h)
    --     draw.RoundedBox(0, 0, 0, w, h, Color(175, 62, 62))
    -- end

    -- plylist:AddColumn(translate.Get("text_sb_ply_num"), 1)
    -- plylist:AddColumn(translate.Get("text_sb_ply_user_group"), 2)
    -- plylist:AddColumn(translate.Get("text_sb_ply_name"), 3)
    -- plylist:AddColumn(translate.Get("text_sb_ply_death"), 4)
    -- plylist:AddColumn(translate.Get("text_sb_ply_ping"), 5)
    -- plylist:AddColumn(translate.Get("text_sb_ply_alive_time"), 6)

    -- local plyInfo = plyInfo or {}
    -- for k, v in pairs(player.GetAll()) do
    --     local line = plylist:AddLine(k, v:GetUserGroup(), v:Name(), v:Deaths(), v:Ping())
    --     function line:Paint(w, h)
    --         draw.RoundedBox(0, 0, 0, w, h, Color(240, 240, 52, 188))
    --     end

    --     table.insert(plyInfo, line)
    --     -- print(line)
    -- end
    -- for _, v in pairs(plylist.Columns) do
    --     function v.Header:Paint(w, h)
    --         draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
    --         -- draw.SimpleText(translate.Get("text_sb_ply_num"), "BM_Small", 0, 0, Color( 255, 255, 255, 255 ), 0, 0)
    --     end

    --     v.Header:SetFont("BM_Small")
    --     v.Header:SetTextColor(color_blue)
    -- end
    -- --显示生存时间
    -- for k, v in pairs(efn_allAliveTime) do
    --     plyInfo[k]:SetColumnText(6, translateTime(v))
    -- end

    -- function GM:HUDDrawScoreBoard()
    --     for k, v in pairs(efn_allAliveTime) do
    --         plyInfo[k]:SetColumnText(5, translateTime(v))
    --     end
    -- end

    function scoreboard:hide()
        if (panel:IsValid()) then
            panel:Remove()
        end
    end
end

function GM:ScoreboardShow()
    net.Start("req_alivetime")
    net.SendToServer()
    net.Start("req_allalivetime")
    net.SendToServer()
    scoreboard:show()
end

function GM:ScoreboardHide()
    scoreboard:hide()
end