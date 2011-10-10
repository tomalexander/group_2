extractPoint = {}

function extractPoint:new(x, y, currentTime, rate)
    local object = {x = x,
                    y = y,
                    currentTime = currentTime,
                    rate = rate }
    setmetatable(object, { __index = extractPoint })
    object.image = display.newImageRect("extractionPoint.png", 50, 50)
    object.health = 100
    extractPoint:addEventListener("touch", extractPoint.touch)
    return object
end

function extractPoint:extract()
    self.currentTime = self.currentTime - self.rate
    if (self.currentTime < 0 ) then
        self.currentTime = 0
    end
    
    if (self.currentTime == 0) then
        display.remove(self.image)
    end
end

function extractPoint:takedamage()
    extractPoint.health = extractPoint.health - 10
    if (extractPoint.health < 0) then
        extractPoint.health = 0
    end
    
    if (extractPoint.health == 0) then
        display.remove(self.image)
    end
end
    

function extractPoint:touch(event)
    if event.x < x+10 and event.x > x-10 and event.y > y-10 and event.y < y+10 then
        extractPoint:extract()
    end
end
