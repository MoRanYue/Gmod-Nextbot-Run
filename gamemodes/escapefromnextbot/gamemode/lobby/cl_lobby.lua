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

net.Receive("open_lobby", function()
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

        draw.DrawText(string.gsub(translate.Get("text_server_title"), "{server}", GetHostName()), "BM_Medium", ScrW()/2, ScrH()/3, color_black, TEXT_ALIGN_CENTER)
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
end)