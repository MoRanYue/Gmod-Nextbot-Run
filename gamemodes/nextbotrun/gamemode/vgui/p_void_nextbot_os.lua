local isPanelOpen = false

concommand.Add("nbr_cl_openvoidos", openVoidOS)

function openVoidOS()
    if (isPanelOpen == false) then
        local frame = vgui.Create("commandPanel")
        frame:MakePopup()
        frame:drawConsole("123123", Color(225,255,255))
        -- frame:ShowCloseButton(false)
        -- frame:SetDraggable(false)
        -- frame:SetTitle("")
        isPanelOpen = true
    else 
        frame:SetVisible(false)

        isPanelOpen = false
    end
end
