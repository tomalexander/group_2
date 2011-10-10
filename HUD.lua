HUD = {}

function HUD:new()
    local object = {}
    object.distanceBar = display.newRect(10, 10, 100, 50)
    object.fuel = display.newRect(10, 80, 100, 50)
    object.distText = display.newText("Distance until next Extraction Point: ", 10, 60, "Helvetica", 12)
    object.fuelText = display.newText("Fuel: ", 10, 130, "Helvetica", 12) 
    object.dead = 0
    object.score = 0
    object.survDistance = 10
    --object.survIcon = display.newImage("survivor.png", 10, 160)
    object.survText = display.newText("Survivors: ", 10, 180, "Helvetica", 12)
    --object.deadIcon = display.newImage("dead.png", 10, 200)
    object.deadText = display.newText("Number dead: ", 10, 220, "Helvetica", 12)
    setmetatable(object, {__index=HUD})
    return object
end

function HUD:setDistanceBar(x)
    self.distanceBar = display.newRect(10, 10, 100-x, 50)
end

function HUD:setFuel(x)
    self.fuel = display.newRect(10, 70, 100-x, 50)
end

function HUD:increaseDeathCounter()
    self.dead = self.dead + 1
end

function HUD:increaseScore()
    self.score = self.score + 10
end

function HUD:newSurvDist(x)
    self.survDistance = x
end

function HUD:decreaseSurvDist(x)
    self.survDistance = self.survDistance - x
end

function HUD:displayHUD(flag)
    if (flag) then
        self.distanceBar.isVisible = true
        self.fuel.isVisible = true
        self.fuelText.isVisible = true
        self.distText.isVisible = true
        --self.survIcon.isVisible = true
        self.survText.isVisible = true
        --self.deadIcon.isVisible = true
        self.deadText.isVisible = true
    else
        self.distanceBar.isVisible = false
        self.fuel.isVisible = false
        self.fuelText.isVisible = false
        self.distText.isVisible = false
        --self.survIcon.isVisible = false
        self.survText.isVisible = false
        --self.deadIcon.isVisible = false
        self.deadText.isVisible = false
    end
end
        