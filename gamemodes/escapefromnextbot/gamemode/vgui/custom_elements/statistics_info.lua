local PANEL = {}

AccessorFunc(PANEL, "row", "GridRow")
AccessorFunc(PANEL, "col", "GridCol")

function PANEL:Init()
    self:SetSize(540, 20)
    -- self:SetColor
end

function PANEL:Paint(s, w, h)
    -- draw.SimpleText("Nextbot名", "DermaDefault", 0, 0, color_black, 0, 0)
end

function PANEL:SetGrid(col, row)
    self.col = col
    self.row = row
end

vgui.Register("StatBar", PANEL, "DPanel")