local PANEL = {}

AccessorFunc(PANEL, "row", "GridRow")

function PANEL:Init()
    self:SetSize(540, 20)
    -- self:SetColor
end

function PANEL:Paint(s, w, h)
    -- draw.SimpleText("Nextbot名", "DermaDefault", 0, 0, color_black, 0, 0)
end

function PANEL:SetRow(row)
    self.row = row
end

vgui.Register("StatBar", PANEL, "DPanel")