SWEP.PrintName = "Parkour ADDON INCLUDED"
SWEP.Author = "Digaly"
SWEP.Instructions = "PLZ!"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 1
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.ViewModelFOV = 54
SWEP.UseHands = true

sound.Add({
    name = "digaly_pk_springboard",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 80,
    pitch = {85, 110},
    sound = "digaly/springboard.wav"
})

sound.Add({
    name = "digaly_pk_climb",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 80,
    pitch = {85, 110},
    sound = "digaly/climb.wav"
})

sound.Add({
    name = "digaly_pk_wallrun",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 80,
    pitch = {85, 110},
    sound = "digaly/wallrun.wav"
})

sound.Add({
    name = "digaly_pk_slide",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 80,
    pitch = {85, 110},
    sound = "digaly/slide.wav"
})

function SWEP:Initialize()
    if CLIENT then return end

    self.initialized = true
    self.owner = nil

    self.regenTimer = CurTime()
    self.springboardTimer = CurTime()
    self.climbTimer = CurTime()
    self.wallRunSoundTimer = CurTime()

    self.isOnGround = false
    self.lastHeight = 0
    self.heightDiff = 0

    self.runSpeed = 400
    self.runSpeedMax = 600
    self.runSpeedMin = 400

    self.trDown = nil
    self.trClimb = nil
    self.trWallLeft = nil
    self.trWallRight = nil
    self.trWallBack = nil

    self.wallLeft = false
    self.wallRight = false
    self.wallBack = false
    self.nearWall = false

    self.slidePower = 0
end

function SWEP:Think()
    if CLIENT then return end

    if not self.initialized then self:Initialize() end
    if not self.owner then self.owner = self:GetOwner() end

    self:CalculateTraces()

    self.owner:SetRunSpeed(self.runSpeed)
    self.owner:SetWalkSpeed(self.runSpeed)

    self.heightDiff = self.owner:GetPos().z - self.lastHeight

    -- Artificially increased jumping height
    self:IncreaseJumpHeight()

    -- Springboard mechanic
    self:Springboard()

    -- Health regeneration
    self:RegenerateHealth()

    -- Wallrunning
    self:Wallrunning()

    -- Climbing, in a sense
    self:Climbing()

    -- Floor sliding
    self:Sliding()

    -- Detect landing
    if not self.isOnGround and self:GetOwner():IsOnGround() then
        self.owner:ViewPunch(Angle(5, 0, 0))

        self.wallRunSoundTimer = 0
        self:StopSound("digaly_pk_wallrun")
    end

    self.isOnGround = self:GetOwner():IsOnGround()

    if self.isOnGround then
        -- Stupid springboard hack
        -- If we're not on a prop, reset the springboard height
        -- This makes it difficult to make springboard work with worldspawn
        if not IsValid(self.trDown.Entity) then
            self.lastHeight = self.owner:GetPos().z
        end
    end
end

function SWEP:CalculateTraces()
    self.trDown = util.TraceLine({
        start = self.owner:GetPos(),
        endpos = self.owner:GetPos() + Vector(0, 0, -5),
        filter = function(ent)
            if (ent:GetClass() == "prop_physics") then return true end
        end
    })

    self.trClimb = util.TraceLine({
        start = self.owner:EyePos(),
        endpos = self.owner:EyePos() +
            Vector(self.owner:GetForward().x, self.owner:GetForward().y, 0) * 18,
        filter = function(ent)
            if (ent:GetClass() == "worldspawn" or ent:GetClass() ==
                "prop_physics") then return true end
        end
    })

    self.trWallRight = util.TraceLine({
        start = self.owner:EyePos(),
        endpos = self.owner:EyePos() +
            Vector(self.owner:GetRight().x, self.owner:GetRight().y, 0) * 30,
        filter = function(ent)
            if (ent:GetClass() == "worldspawn" or ent:GetClass() ==
                "prop_physics") then return true end
        end
    })

    self.trWallLeft = util.TraceLine({
        start = self.owner:EyePos(),
        endpos = self.owner:EyePos() +
            Vector((-self.owner:GetRight()).x, (-self.owner:GetRight()).y, 0) *
            30,
        filter = function(ent)
            if (ent:GetClass() == "worldspawn" or ent:GetClass() ==
                "prop_physics") then return true end
        end
    })

    self.trWallBack = util.TraceLine({
        start = self.owner:EyePos(),
        endpos = self.owner:EyePos() +
            Vector((-self.owner:GetForward()).x, (-self.owner:GetForward()).y, 0) *
            30,
        filter = function(ent)
            if (ent:GetClass() == "worldspawn" or ent:GetClass() ==
                "prop_physics") then return true end
        end
    })

    self.wallLeft = self.trWallLeft.Entity:IsWorld() or
                        IsValid(self.trWallLeft.Entity)
    self.wallRight = self.trWallRight.Entity:IsWorld() or
                         IsValid(self.trWallRight.Entity)
    self.wallBack = self.trWallBack.Entity:IsWorld() or
                        IsValid(self.trWallBack.Entity)
    self.nearWall = self.wallLeft or self.wallRight or self.wallBack
end

function SWEP:IncreaseJumpHeight()
    if self.owner:KeyPressed(IN_JUMP) and self.isOnGround then
        -- forwardReduction will 'negate' the long jump if applicable
        local forwardReduction = Vector(0, 0, 0)
        if self.owner:KeyDown(IN_FORWARD) then
            forwardReduction = self.owner:GetForward() * -200
        end

        self.owner:SetVelocity(forwardReduction + Vector(0, 0, 45))
    end
end

function SWEP:Springboard()
    if self:CanSpringboard() then
        self.owner:SetVelocity(self.owner:GetForward() * -130 +
                                   Vector(0, 0, 650))

        self.owner:ViewPunch(Angle(15, 0, 0))
        self:EmitSound("digaly_pk_springboard")

        self.springboardTimer = CurTime()
    end
end

function SWEP:CanSpringboard()
    return self.owner:KeyDown(IN_FORWARD) and self.owner:KeyDown(IN_JUMP) and
               self.trDown.Entity and IsValid(self.trDown.Entity) and
               self.heightDiff > 30 and (CurTime() - self.springboardTimer) > 1
end

function SWEP:RegenerateHealth()
    if CurTime() - self.regenTimer > 0.5 then
        if (self.owner:Health() < self.owner:GetMaxHealth()) then
            self.owner:SetHealth(self.owner:Health() + 1)
        end

        self.regenTimer = CurTime()
    end
end

function SWEP:Climbing()
    if self:CanClimb() then
        self.owner:SetVelocity(self.owner:GetForward() * 100 + Vector(0, 0, 300))
        self.climbTimer = CurTime()
        self:EmitSound("digaly_pk_climb")
    end
end

function SWEP:CanClimb()
    return self.owner:KeyDown(IN_JUMP) and
               (self.trClimb.Entity:IsWorld() or IsValid(self.trClimb.Entity)) and
               (CurTime() - self.climbTimer) > 2
end

function SWEP:Wallrunning()
    if self:CanWallrun() then
        self.owner:SetVelocity(Vector(0, 0, 4))

        if self.wallLeft then
            self.owner:ViewPunch(Angle(0, -1, 0))
        else
            self.owner:ViewPunch(Angle(0, 1, 0))
        end

        -- Jump from wallrun, disabled because it's too OP right now
        -- if self.owner:KeyPressed(IN_JUMP) and self.wallBack and
        --    (not (self.wallLeft or self.wallRight)) then
        --    self.owner:SetVelocity(self.owner:GetForward() * 200 +
        --                               Vector(0, 0, 370))
        -- end

        if CurTime() - self.wallRunSoundTimer > 5 then
            self:EmitSound("digaly_pk_wallrun")
            self.wallRunSoundTimer = CurTime()
        end
    end

    if not self.nearWall or self.isOnGround then
        self.wallRunSoundTimer = 0
        self:StopSound("digaly_pk_wallrun")
    end
end

function SWEP:CanWallrun()
    return self.owner:KeyDown(IN_FORWARD) and not self.isOnGround and
               self.nearWall
end

function SWEP:Sliding()
    if self.owner:KeyPressed(IN_DUCK) and self:CanSlide() then
        self.slidePower = 100
        self:EmitSound("digaly_pk_slide")
    end

    if self:CanSlide() then
        self.owner:SetVelocity(self.owner:GetForward() * self.slidePower)
        if self.slidePower > 0 then self.slidePower = self.slidePower - 1 end
    end
end

function SWEP:CanSlide()
    return self.owner:KeyDown(IN_FORWARD) and self.owner:KeyDown(IN_DUCK) and
               self.isOnGround
end
