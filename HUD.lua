require "sprite"

HUD = {}

indicatorL = sprite.newSpriteSheet("img/hud_distance.png", 150, 106)
indicatorLset = sprite.newSpriteSet(indicatorL, 1, 6)

indicatorR = sprite.newSpriteSheet("img/hud_distance_reverse.png", 150, 106)
indicatorRset = sprite.newSpriteSet(indicatorR, 1, 6)

function HUD:new()
    local object = {}
    object.distBack = display.newImage("img/hud_health_back.png", 770, 400)
    object.distFill = display.newImage("img/hud_health_middle.png", 770, 400)
    object.distFront = display.newImage("img/hud_health_front.png", 770, 400)
    object.distY = object.distFill.y
    object.distBack:rotate(90)
    object.distFill:rotate(90)
    object.distFront:rotate(90)
    
    object.lives = 6
    
    object.warningLeft = display.newImage("img/hud_warning.png", -25, 100)
    object.warningLeft:scale(0.5, 0.5)
    object.warningRight = display.newImage("img/hud_warning.png", 800, 100)
    object.warningRight:scale(0.5, 0.5)
    object.warningLeft.isVisible = false
    object.warningRight.isVisible = false

    --object.distanceBar = display.newRect(10, 10, 300, 25)
    --object.fuel = display.newRect(10, 80, 300, 25)
    object.fuelBack = display.newImage("img/hud_resource_back.png", -100, 400)
    object.fuel = display.newImage("img/hud_resource_middle.png", -100, 400)
    object.fuelFront = display.newImage("img/hud_resource_front.png", -100, 400)
    object.fuelY = object.fuel.y
    object.fuelBack:rotate(-90)
    object.fuel:rotate(-90)
    object.fuelFront:rotate(-90)
    
    object.left_indicator = sprite.newSprite(indicatorLset)
    object.left_indicator.currentFrame = object.dead
    object.left_indicator.x = 900
    object.left_indicator.y = 80
    
    object.right_indicator = sprite.newSprite(indicatorRset)
    object.right_indicator.currentFrame = object.dead
    object.right_indicator.x = 55
    object.right_indicator.y = 80

    object.left_indicator_text = display.newText("1000", object.left_indicator.x -60, object.left_indicator.y -35, "Helvetica", 18)
    object.right_indicator_text = display.newText("2000", object.right_indicator.x, object.right_indicator.y -35, "Helvetica", 18)

    
    object.left_indicator.isVisible = true
    object.right_indicator.isVisible = false
    
    
    --object.distText = display.newText("Distance until Extraction Point: ", 680, 10, "Helvetica", 20)
    --object.fuelText = display.newText("Fuel: ", 10, 10, "Helvetica", 24) 
    object.dead = 0
    object.score = 0
    object.scoreText = display.newText("Score: "..object.score, 10, 70, "Helvetica", 24)
    object.survDistance = 0
    --object.survIcon = display.newImage("survivor.png", 10, 160)
    object.survIcon = display.newCircle(900, 300, 20)
    --object.survText = display.newText("Survivors: ", 10, 180, "Helvetica", 24)
    --object.deadIcon = display.newImage("dead.png", 10, 200)
    --object.deadText = display.newText("Number dead: ", 10, 220, "Helvetica", 24)
	
	object.group = display.newGroup()
	object.group:insert(object.distBack)
	object.group:insert(object.distFill)
	object.group:insert(object.distFront)
	
    object.group:insert(object.left_indicator)
    object.group:insert(object.right_indicator)
    object.group:insert(object.left_indicator_text)
    object.group:insert(object.right_indicator_text)

    
    object.group:insert(object.warningLeft)
    object.group:insert(object.warningRight)
    
	object.group:insert(object.fuelBack)
	object.group:insert(object.fuel)
	object.group:insert(object.fuelFront)
	
	--object.group:insert(object.distText)
	--object.group:insert(object.fuelText)
	object.group:insert(object.scoreText)
	object.group:insert(object.survIcon)
	--object.group:insert(object.survText)
	--object.group:insert(object.deadText)
	
    setmetatable(object, {__index=HUD})
    return object
end

function HUD:setDistanceBar(x)
    --self.distanceBar:removeSelf()
    if x < 0 then
        x = x * -1
    end
    if x > 1 then
        x = 1
    end
    
    self.distFill.y = self.distY + (215-215*x)
    --self.distanceBar = display.newRect(10, 10, 300*x, 25)
 
end

function HUD:setFuel(amount)
	-- convert 0 to 150 to 0 to 215 pixels
	self.fuel.y = self.fuelY + (150 - amount)*215/150
end

function HUD:addKill()
	self.dead = self.dead + 1
	self.left_indicator.currentFrame = self.dead + 1
	self.right_indicator.currentFrame = self.dead + 1
	if self.dead >= 5 then
		display.getCurrentStage().x = 0
		high_scores:display_name_box()
		-- GAMEOVER
	end
end

function HUD:deFuel()
    --self.fuel = display.newRect(10, 70, 300-x, 25)
    self.fuel.y = self.fuel.y + (215/10)
    if self.fuel.y > self.fuelY + 215 then
        self.fuel.y = self.fuelY + 215
    end    
end

function HUD:reFuel()
    self.fuel.y = self.fuel.y - (215/20)
    if self.fuel.y < self.fuelY then
        self.fuel.y = self.fuelY
    end
end

function HUD:increaseDeathCounter()
    self.dead = self.dead + 1
end

function HUD:increaseScore()
    self.score = self.score + 10
   self.scoreText:removeSelf()
   self.scoreText = display.newText("Score: "..self.score, 10, 70, "Helvetica", 24)
   self.group:insert(self.scoreText)
end

function HUD:newSurvDist(x)
    self.survDistance = x
    self.survIcon:removeSelf()
    if ((100/(x+1)) < 20) then
        self.survIcon = display.newCircle(900, 300, 20)
    else
        self.survIcon = display.newCircle(900, 300, (100/(x+1)))
    end
	self.group:insert(self.survIcon)
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
        
        --self.fuelText.isVisible = true
        --self.distText.isVisible = true
        self.survIcon.isVisible = true
        --self.survText.isVisible = true
        --self.deadIcon.isVisible = true
        --self.deadText.isVisible = true
    else
        --self.distanceBar.isVisible = false
        self.distFill.isVisible = false
        self.distBack.isVisible = false
        self.distFront.isVisible = false
       
        self.fuel.isVisible = false
        self.fuelBack.isVisible = false
        self.fuelFront.isVisible = false
        
        self.scoreText.isVisible = false
        
        --self.fuelText.isVisible = false
        --self.distText.isVisible = false
        self.survIcon.isVisible = false
        --self.survText.isVisible = false
        --self.deadIcon.isVisible = false
        --self.deadText.isVisible = false
    end
end

function HUD:update(platDist, SDist, exDist, initExDist, alert)
   local old_plat_dist = platDist
   if platDist < 960/2 then
        platDist = 960/2
    end
    --self:setDistanceBar((exDist - platDist)/initExDist)
    self:newSurvDist(SDist)
    
    if alert < platDist and alert ~= 0 then
        self.warningLeft.isVisible = true
        self.warningRight.isVisible = false
    elseif alert > platDist and alert ~=0 then
        self.warningRight.isVisible = true
        self.warningLeft.isVisible = false
    end
    print(old_plat_dist)
    if platDist < exDist then
        self.right_indicator.isVisible = false
        self.left_indicator.isVisible = true
        --self.left_indicator.currentFrame = self.lives
       self.left_indicator_text.isVisible = true
       self.right_indicator_text.isVisible = false
    else
        self.right_indicator.isVisible = true
        self.left_indicator.isVisible = false
        --self.right_indicator.currentFrame = self.lives
       self.right_indicator_text.isVisible = true
       self.left_indicator_text.isVisible = false
    end
    
    --self:newSurvDist(SDist - platDist)
end

    

        