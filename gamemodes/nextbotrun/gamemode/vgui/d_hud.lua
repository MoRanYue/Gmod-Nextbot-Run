local nbCount = 0
local nbMax = 0
local nbStatus = 0

net.Receive("nbInfo", function(len)
    nbCount = net.ReadInt(9)
    nbMax = net.ReadInt(9)
    nbStatus = net.ReadInt(9)
    print("Received the NBINFO in HUD")
    -- print()
end)

net.Start("req_nbInfo")
net.SendToServer()

surface.CreateFont("DL_Large", {
    font = "DermaLarge",
    size = ScreenScale(13),
    weight = 500
})
surface.CreateFont("DL_Medium", {
    font = "DermaLarge",
    size = ScreenScale(9),
    weight = 500
})
surface.CreateFont("DL_Small", {
    font = "DermaLarge",
    size = ScreenScale(7),
    weight = 500
})
surface.CreateFont("DDB_Medium", {
    font = "DermaDefaultBold",
    size = ScreenScale(10)
})
surface.CreateFont("DDB_Small", {
    font = "DermaDefaultBold",
    size = ScreenScale(5)
})

--隐藏原本的hud
hook.Add("HUDShouldDraw", "hideDefaultHud", function(name)
    net.Start("req_nbInfo")
    net.SendToServer()

    for k, v in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"}) do
        if (name == v) then
            return false
        end
    end
end)

--绘制hud
hook.Add("HUDPaint", "nextbotHud", function()
    local cl = LocalPlayer()

    if (nbStatus == 1) then
        nbStatus = NBR.lang.hud_nbstatus_1
    elseif (nbStatus == 0) then
        nbStatus = NBR.lang.hud_nbstatus_0
    end

    --Nextbot信息
    draw.RoundedBox(15, -10, 20, 300, 200, Color(255, 120, 120, 150))
    draw.SimpleText(string.format(NBR.lang.hud_nbinfo_num, nbCount, nbMax), "DL_Medium", 0, 30, Color(255,255,255), 0, 0)
    draw.SimpleText(string.format(NBR.lang.hud_nbinfo_status, nbStatus), "DL_Small", 0, 70, Color(255,255,255), 0, 0)

    draw.SimpleText(string.format(NBR.lang.hud_death_count, LocalPlayer():Deaths()), "DL_Medium", 0, 100, Color(255,12,12), 0, 0)

    --玩家信息
    if (cl:Health() >= 100 || cl:Health() <= 0) then
        
    elseif (cl:Armor() <= 0) then
        draw.RoundedBox(4, -10, ScrH() - 60, 360, 60, Color(50, 50, 50, 225))

        draw.RoundedBox(15, 30, ScrH() - 40, 300, 10, Color(255, 200, 12))
        draw.RoundedBox(15, 30, ScrH() - 40, math.Clamp(cl:Health(), 0, 100) * 3, 10, Color(255, 12, 12))
        draw.SimpleText(tostring(cl:Health()), "DermaDefaultBold", 10, ScrH() - 40 - 3, Color(0, 255, 255), 0, 0)
    else 
        draw.RoundedBox(4, -10, ScrH() - 60, 360, 60, Color(50, 50, 50, 225))

        draw.RoundedBox(15, 30, ScrH() - 40, 300, 10, Color(255, 200, 12))
        draw.RoundedBox(15, 30, ScrH() - 40, math.Clamp(cl:Health(), 0, 100) * 3, 10, Color(255, 12, 12))
        draw.SimpleText(tostring(cl:Health()), "DermaDefaultBold", 5, ScrH() - 40 - 3, Color(0, 255, 255), 0, 0)

        draw.RoundedBox(15, 30, ScrH() - 20, 300, 10, Color(255, 200, 255))
        draw.RoundedBox(15, 30, ScrH() - 20, math.Clamp(cl:Armor(), 0, 100) * 3, 10, Color(12, 100, 100))
        draw.SimpleText(tostring(cl:Armor()), "DermaDefaultBold", 5, ScrH() - 20 - 3, Color(255, 255, 255), 0, 0)
    end

    --弹药
    if (cl:GetActiveWeapon():IsValid()) then
        if (cl:GetActiveWeapon():Clip1() != -1 && cl:GetActiveWeapon():Clip1() != nil) then
            draw.RoundedBox(4, -10, ScrH() - 150, 150, 70, Color(10, 10, 10, 225))

            draw.SimpleText(string.format(NBR.lang.hud_ammo, tostring(cl:GetActiveWeapon():Clip1()), tostring(cl:GetAmmoCount(cl:GetActiveWeapon():GetPrimaryAmmoType()))), "DDB_Small", 10, ScrH() - 140)

            if (cl:GetAmmoCount(cl:GetActiveWeapon():GetSecondaryAmmoType()) > 0 && cl:GetAmmoCount(cl:GetActiveWeapon():GetSecondaryAmmoType()) != nil) then
                draw.SimpleText(string.format(NBR.lang.hud_sec_ammo, tostring(cl:GetAmmoCount(cl:GetActiveWeapon():GetSecondaryAmmoType()))), "DDB_Small", 10, ScrH() - 115)
            end
        elseif (cl:GetAmmoCount(cl:GetActiveWeapon():GetPrimaryAmmoType()) != 0) then
            draw.RoundedBox(4, -10, ScrH() - 150, 120, 43, Color(10, 10, 10, 225))

            draw.SimpleText(string.format(NBR.lang.hud_ammo_single, tostring(cl:GetAmmoCount(cl:GetActiveWeapon():GetPrimaryAmmoType()))), "DDB_Small", 10, ScrH() - 140)
        end
    end
end)