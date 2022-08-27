surface.CreateFont("CF_Large", {
    font = "DebugFixed",
    size = ScreenScale(13)
    -- weight = 500
})
surface.CreateFont("CF_Small", {
    font = "DebugFixed",
    sieze = ScreenScale(7)
})

local PANEL = PANEL or {}
local panels = FindMetaTable("Panel")
function panels:drawConsole(text, color)
    draw.DrawText(text .. "\n", "CF_Small", 3, 130, Color(255,255,255))
end

function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:Center()
    self:SetVisible(true)
    -- self:ShowCloseButton(false)
    -- self:SetDraggable(false)
    -- self:SetTitle("")
end

function PANEL:Paint(s, w, h)
    draw.RoundedBox(0, 0, 0, ScrW(), 100, color_black)
    draw.SimpleText("虚空 - 控制台", "CF_Large", 30, 20, Color(211,211,211))
    draw.RoundedBox(0, 0, 100, ScrW(), 20, Color(11, 12, 13))
    draw.RoundedBox(0, 0, 120, ScrW(), ScrH() - 120, Color(165, 42, 42))
end

vgui.Register("commandPanel", PANEL, "Panel")