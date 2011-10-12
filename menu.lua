mainMenu = {}
i = 1

function mainMenu:new()
    local object = {}
    object.instructions = {}
    
    object.instructions1 = display.newImage("img/tutorial/Screen-1.png", 0, 0)
    table.insert(object.instructions, object.instructions1)
    
    --object.instructions2 = {}
    table.insert(object.instructions, display.newImage("img/tutorial/Screen-2-1.png", 0, 0))
    table.insert(object.instructions, display.newImage("img/tutorial/Screen-2-2.png", 0, 0))
    table.insert(object.instructions, display.newImage("img/tutorial/Screen-2-3.png", 0, 0))
    table.insert(object.instructions, display.newImage("img/tutorial/Screen-2-4.png", 0, 0))
    --table.insert(object.instructions, object.instructions2)
    
    --object.instructions3 = {}
    table.insert(object.instructions, display.newImage("img/tutorial/Screen-3-1.png", 0, 0))
    table.insert(object.instructions, display.newImage("img/tutorial/Screen-3-2.png", 0, 0))
    --table.insert(object.instructions, object.instructions3)
    
    object.instructions4 = display.newImage("img/tutorial/Screen-4.png", 0, 0)
    table.insert(object.instructions, object.instructions4)
    
    --object.instructions5 = {}
    table.insert(object.instructions, display.newImage("img/tutorial/Screen-5-1.png", 0, 0))
    table.insert(object.instructions, display.newImage("img/tutorial/Screen-5-2.png", 0, 0))
    table.insert(object.instructions, display.newImage("img/tutorial/Screen-5-3.png", 0, 0))
    --table.insert(object.instructions, object.instructions5)
    
    --object.instructions6 = {}
    table.insert(object.instructions, display.newImage("img/tutorial/Screen-6-1.png", 0, 0))
    table.insert(object.instructions, display.newImage("img/tutorial/Screen-6-2.png", 0, 0))
    table.insert(object.instructions, display.newImage("img/tutorial/Screen-6-3.png", 0, 0))
    table.insert(object.instructions, display.newImage("img/tutorial/Screen-6-4.png", 0, 0))
    --table.insert(object.instructions, object.instructions6)
    
    --object.instructions7 = {}
    table.insert(object.instructions, display.newImage("img/tutorial/Screen-7-1.png", 0, 0))
    table.insert(object.instructions, display.newImage("img/tutorial/Screen-7-2.png", 0, 0))
    table.insert(object.instructions, display.newImage("img/tutorial/Screen-7-3.png", 0, 0))
    table.insert(object.instructions, display.newImage("img/tutorial/Screen-7-4.png", 0, 0))
    --table.insert(object.instructions, object.instructions7)
    
    object.instructions8 = display.newImage("img/tutorial/Screen-8.png", 0, 0)
    table.insert(object.instructions, object.instructions8)
    
    object.instructions9 = display.newImage("img/tutorial/Screen-9.png", 0, 0)
    table.insert(object.instructions, object.instructions9)
    
    object.instructions10 = display.newImage("img/tutorial/Screen-10.png", 0, 0)
    table.insert(object.instructions, object.instructions10)
    
    for i,v in ipairs(object.instructions) do
        v.isVisible = false
    end
    
    object.background = display.newImage("img/title.png", 0, 0)
    object.button1 = display.newImage("img/menu_tutorial.png", 50, 425)
    object.button2 = display.newImage("img/menu_back.png", 0, 180)
    object.button3 = display.newImage("img/menu_next.png", 878, 180)
    object.playbutton = display.newImage("img/menu_play.png", 336, 425)
    object.highscorebutton = display.newImage("img/menu_highscore.png", 622, 425)
    
    
    
    object.button2.isVisible = false
    object.button3.isVisible = false
    
    object.help = false
    object.play = false
    setmetatable(object, {__index = mainMenu})
    return object
end


--[[function mainMenu:setHelp(help)
    
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
end]]

function mainMenu:setHelp()
        
    self.background.isVisible = false
    self.button1.isVisible = false
    self.button2.isVisible = true
    self.button3.isVisible = true
    self.playbutton.isVisible = false
    self.highscorebutton.isVisible = false
    self.instructions[1].isVisible = true
end

function mainMenu:Play()
    self.instructions.isVisible = false
    self.background.isVisible = false
    self.button2.isVisible = false
    self.button1.isVisible = false
    self.highscorebutton.isVisible = false
    self.playbutton.isVisible = false
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
end]]

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
end
