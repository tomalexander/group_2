physics = require "physics"

extractPoint = {}

function extractPoint:new(x, y, currentTime, rate)
    local object = {x = x,
                    y = y,
                    currentTime = currentTime,
                    rate = rate }
    setmetatable(object, { __index = extractPoint })
    object.image = display.newImageRect("extractionPoint.png", 50, 50)
    object.health = 100
    object.shield = display.newCircle(x, y, 50)
    object.shield:setFillColor(0, 150, 20)
    object.saved = false
    object.destroyed = false
    object.initialDistance = x-256
    physics.addBody(object.shield, "static", {friction = 0.5, bounce = 0.5})
    
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
        self.destroyed = true
    end
end