physics = require "physics"
require "sprite"

exSpriteSheet = sprite.newSpriteSheet("img/extraction_shield.png", 335, 175)
exSpriteSet = sprite.newSpriteSet(exSpriteSheet, 1, 7)
sprite.add(exSpriteSet, "idle", 1, 7, 1500, 0)

shield_shape = {-167,87.5,-125,-25,-83.5,-50,0,-87.5,83.5,-50,125,-25,167,87.5}

extractPoint = {}

function extractPoint:new(x, y, currentTime, rate)
    local object = {x = x,
                    y = y,
                    currentTime = currentTime,
                    rate = rate }
    setmetatable(object, { __index = extractPoint })
    --object.image = display.newImageRect("extractionPoint.png", 50, 50)
    object.health = 100
    --object.shield = display.newCircle(x, y, 50)
    object.shield = sprite.newSprite(exSpriteSet)
    object.shield.x = x
    object.shield.y = y
    object.noShield = display.newImage("img/extraction_noshield.png", x, y)
    object.noShield.isVisible = false
    object.noShield.isFixedRotation = true
    object.shield.isFixedRotation = true
    
    physics.addBody(object.noShield, "static", {friction = 1, bounce = .05, shape = shield_shape})
    object.saved = false
    object.destroyed = false
    object.initialDistance = x-256
    physics.addBody(object.shield, "dynamic", {density = 20, friction = 1, bounce = 0.01, shape = shield_shape, filter = { categoryBits = 1, maskBits = 100 }})
    
    object.shield:prepare("idle")
    object.shield:play()
    --physics.addBody(object.shield, "static", {friction = 0.5, bounce = 0.5})
    
    --object.touch = extractPointTouch
    --object:addEventListener("touch", object)
    return object
end

function extractPoint:extract()
    self.currentTime = self.currentTime - self.rate
    if (self.currentTime < 0 ) then
        self.currentTime = 0
    end
    
    if (self.currentTime == 0) then
        --self.image.isVisible = false
        self.shield.isVisible = false
        self.saved = true
    end
end

function extractPoint:takedamage(x)
    self.health = self.health - x
    self.shield.alpha = (self.health/100)
    if (self.health < 0) then
        self.health = 0
    end
    
    if (self.health == 0) then
        --self.image.isVisible = false
        self.shield.isVisible = false
        self.noShield.isVisible = true
    end
end

function extractPoint:blow_up()
    self.noShield.isVisible = false
    self.destroyed = true
end