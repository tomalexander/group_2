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

function extractPoint:takedamage()
    extractPoint.health = extractPoint.health - 10
    self.shield.alpha = (extractPoint.health/100)
    if (extractPoint.health < 0) then
        extractPoint.health = 0
    end
    
    if (extractPoint.health == 0) then
        --self.image.isVisible = false
        self.shield.isVisible = false
        self.destroyed = true
    end
end