HUD = {}

function HUD:new()
    local object = {}
    object.distBack = display.newImage("img/hud_health_back.png", 700, 32)
    object.distFill = display.newImage("img/hud_health_middle.png", 700, 32)
    object.distFront = display.newImage("img/hud_health_front.png", 700, 32)
    object.distX = object.distFill.x
    
    
    --object.distanceBar = display.newRect(10, 10, 300, 25)
    --object.fuel = display.newRect(10, 80, 300, 25)
    object.fuelBack = display.newImage("img/hud_resource_back.png", 0, 32)
    object.fuel = display.newImage("img/hud_resource_middle.png", 0, 32)
    object.fuelFront = display.newImage("img/hud_resource_front.png", 0, 32)
    object.fuelX = object.fuel.x
    
    object.distText = display.newText("Distance until Extraction Point: ", 680, 10, "Helvetica", 20)
    object.fuelText = display.newText("Fuel: ", 10, 10, "Helvetica", 24) 
    object.dead = 0
    object.score = 0
    object.scoreText = display.newText("Score: "..object.score, 10, 70, "Helvetica", 24)
    object.survDistance = 0
    --object.survIcon = display.newImage("survivor.png", 10, 160)
    object.survIcon = display.newCircle(900, 300, 20)
    object.survText = display.newText("Survivors: ", 10, 180, "Helvetica", 24)
    --object.deadIcon = display.newImage("dead.png", 10, 200)
    object.deadText = display.newText("Number dead: ", 10, 220, "Helvetica", 24)
    setmetatable(object, {__index=HUD})
    return object
end

function HUD:setDistanceBar(x)
    --self.distanceBar:removeSelf()
    if x < 0 then
        x = x * -1
    end
    self.distFill.x = self.distX + (215-215*x)
    --self.distanceBar = display.newRect(10, 10, 300*x, 25)
 
end

function HUD:setFuel(x)
    --self.fuel = display.newRect(10, 70, 300-x, 25)
    self.fuel.x = self.fuelX - (215-215*x)
    
end

function HUD:increaseDeathCounter()
    self.dead = self.dead + 1
end

function HUD:increaseScore()
    self.score = self.score + 10
end

function HUD:newSurvDist(x)
    self.survDistance = x
    self.survIcon:removeSelf()
    if ((100/(x+1)) < 20) then
        self.survIcon = display.newCircle(900, 300, 20)
    else
        self.survIcon = display.newCircle(900, 300, (100/(x+1)))
    end
end

function HUD:displayHUD(flag)
    if (flag) then
        --self.distanceBar.isVisible = true
        self.distFill.isVisible = true
        self.distBack.isVisible = true
        self.distFront.isVisible = true
        
        self.fuel.isVisible = true
        self.fuelBack.isVisible = true
        self.fuelFront.isVisible = true
        
        self.scoreText.isVisible = true
        
        self.fuelText.isVisible = true
        self.distText.isVisible = true
        self.survIcon.isVisible = true
        self.survText.isVisible = true
        --self.deadIcon.isVisible = true
        self.deadText.isVisible = true
    else
        --self.distanceBar.isVisible = false
        self.distFill.isVisible = false
        self.distBack.isVisible = false
        self.distFront.isVisible = false
       
        self.fuel.isVisible = false
        self.fuelBack.isVisible = false
        self.fuelFront.isVisible = false
        
        self.scoreText.isVisible = false
        
        self.fuelText.isVisible = false
        self.distText.isVisible = false
        self.survIcon.isVisible = false
        self.survText.isVisible = false
        --self.deadIcon.isVisible = false
        self.deadText.isVisible = false
    end
end

function HUD:update(platDist, SDist, exDist, initExDist)
    if platDist < 256 then
        platDist = 256
    end
    self:setDistanceBar((exDist - platDist)/initExDist)
    self:newSurvDist(SDist)
    --self:newSurvDist(SDist - platDist)
end

    

        