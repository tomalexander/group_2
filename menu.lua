mainMenu = {}

function mainMenu:new()
    local object = {}
    object.background = display.newImage("img/background.png", 0, 0)
    object.instructions = display.newImage("img/instructions.png", 0, 0)
    object.button1 = display.newImage("img/helpButton.png", display.contentWidth/4, display.contentHeight/4)
    object.button2 = display.newImage("img/backButton.png", display.contentWidth/4, display.contentHeight/4)
    object.instructions.isVisible = false
    object.help = false
    object.play = false
    setmetatable(object, {__index = mainMenu})
    return object
end

--[[function mainMenu:setHelp(help)
    
    if help then
        print("one")
        mainMenu.instructions.isVisible = false
        mainMenu.background.isVisible = true
        mainMenu.button1.isVisible = false
        mainMenu.button2.isVisible = true
        mainMenu.help = true
    else
        print("two")
        mainMenu.instructions.isVisible = true
        mainMenu.background.isVisible = false
        mainMenu.button2.isVisible = false
        mainMenu.button1.isVisible = true
        mainMenu.help = false
    end
end]]

function mainMenu:setHelp(help)
    
    if help then
        print("one")
        self.instructions.isVisible = false
        self.background.isVisible = true
        self.button1.isVisible = false
        self.button2.isVisible = true
        self.help = true
    else
        print("two")
        self.instructions.isVisible = true
        self.background.isVisible = false
        self.button2.isVisible = false
        self.button1.isVisible = true
        self.help = false
    end
end

--[[function mainMenu:Play()
    mainMenu.instructions.isVisible = false
    mainMenu.background.isVisible = false
    mainMenu.button2.isVisible = false
    mainMenu.button1.isVisible = false
    mainMenu.help = false
    Runtime:removeEventListener("touch", mainMenu.touch)
    mainMenu.play = true
end]]

function mainMenu:Play()
    self.instructions.isVisible = false
    self.background.isVisible = false
    self.button2.isVisible = false
    self.button1.isVisible = false
    self.help = false
    Runtime:removeEventListener("touch", self.touch)
    self.play = true
end

--[[function mainMenu.touch(event)
    if event.phase == "began" then
        if (event.x > display.contentWidth/4 and event.x < display.contentWidth*3/4
        and event.y > display.contentHeight/4 and event.y < display.contentHeight*3/4) then
            if mainMenu.help then
                mainMenu:setHelp(false)
            else
                mainMenu:setHelp(true)
            end
            
        elseif (event.x > display.contentWidth*3/4 and event.y > display.contentHeight*3/4) then
            mainMenu:Play()
        end
    end
end

function mainMenu.touch(event)
    if event.phase == "began" then
        if (event.x > display.contentWidth/4 and event.x < display.contentWidth*3/4
        and event.y > display.contentHeight/4 and event.y < display.contentHeight*3/4) then
            if self.help then
                self:setHelp(false)
            else
                self:setHelp(true)
            end
            
        elseif (event.x > display.contentWidth*3/4 and event.y > display.contentHeight*3/4) then
            self:Play()
        end
    end
end]]


            

    