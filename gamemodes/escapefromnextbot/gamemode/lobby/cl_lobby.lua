net.Receive("open_lobby", openLobby)

surface.CreateFont("BM_Large", {
    font = "Tahoma",
    size = ScreenScale(15),
    weight = 500
})
surface.CreateFont("BM_Medium", {
    font = "Tahoma",
    size = ScreenScale(10),
    weight = 500
})
surface.CreateFont("BM_Small", {
    font = "Tahoma",
    size = ScreenScale(7),
    weight = 500
})

function openLobby()
    -- 创建vgui
    local frame = vgui.Create("DFrame")
    frame:SetSize(ScrW(), ScrH())
    frame:Center()
    frame:SetVisible(true)
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)
    frame:SetTitle("")
    frame.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(200, 200, 200, 255))
    end
    frame:MakePopup()

    local startButton = vgui.Create("DButton", frame)
    startButton:SetSize(200, 75)
    startButton:SetPos( ScrW()/2 - (200/2), ScrH()/1.5 - (75/2) )
    startButton:SetFont("BM_Large")
    startButton:SetText(translate.Get("button_close"))
    startButton:SetTextColor(Color(25, 50, 75))
    startButton.DoClick = function()
        frame:Close()
    end

    local svTitle = vgui.Create("DLabel", frame)
    -- svTitle:SetPos(ScrW()/2 - 200, ScrH()/2)
    svTitle:CenterHorizontal()
    -- svTitle:SetSize(200, 75)
    -- svTitle:SetPos(ScrW()/2, ScrH()/3 - (75/2))
    svTitle:SetFont("BM_Medium")
    svTitle:Center()
    -- TrAnSlAtEaBlE
    svTitle:SetText(string.gsub(translate.Get("text_server_title"), "{server}", GetHostName()))
    -- svTitle:Center()
    svTitle:SizeToContents()
    svTitle:SetTextColor(Color(114, 51, 4))
end