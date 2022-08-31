surface.CreateFont("DDBC_Large", {
    font = "DermaDefaultBold",
    size = ScreenScale(13)
    -- weight = 500
})
surface.CreateFont("DDBC_Small", {
    font = "DermaDefaultBold",
    sieze = ScreenScale(7)
})

local PANEL = PANEL or {}
-- local panels = FindMetaTable("Panel")

-- AccessorFunc(PANEL, "c_console_text", "PConsoleText", FORCE_STRING)
local c_console_text = ""

function PANEL:Close()
	self:SetVisible( false )
	self:Remove()
end

function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:Center()

    local consoleBut = vgui.Create("DButton", self)
    consoleBut:SetSize(75, 75)
    consoleBut:SetPos(ScrW() - 100, 30)
    consoleBut:SetFont("DDBC_Large")
    consoleBut:SetText("X")
    -- consoleBut:SetColor(Color(255, 12, 13))
    consoleBut:SetTextColor(color_black)
    consoleBut.DoClick = function()
        self:Close()
    end
end

function PANEL:Paint(s, w, h)
    draw.RoundedBox(0, 0, 0, ScrW(), 100, color_black)
    draw.SimpleText(NBR.lang.void_console_title, "DDBC_Large", 30, 20, Color(211,211,211))
    draw.RoundedBox(0, 0, 100, ScrW(), 20, Color(11, 12, 13))
    draw.RoundedBox(0, 0, 120, ScrW(), ScrH() - 120, Color(165, 42, 42))
end

function PANEL:drawConsole(text, color)
    c_console_text = c_console_text .. "\n" .. text
    for k, v in pairs(string.Split(c_console_text, "\n")) do
        draw.SimpleText(v, "DDBC_Large", 5, 110, color)
    end

    -- c_console_text = c_console_text .. "\n" .. text
    -- local c_console_txt = vgui.Create("DLabel", self)
    -- c_console_txt:SetPos(3, 200)
    -- c_console_txt:SetFont("DDBC_Large")
    -- c_console_txt:SetTextColor(color)
    -- c_console_txt:SetText(c_console_text)
end

vgui.Register("commandPanel", PANEL, "Panel")