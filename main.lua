sprite = require "sprite"
physics = require "physics"

-- Quick hackish method to force the background to be drawn first
local background = display.newImage("img/background.png", true)

shield_h = require "shield"
meteor_h = require "meteor"
meteor_generator_h = require "meteor_generator"
platform_h = require "platform"
ground_h = require "ground"
survivor_h = require "survivor"
highscores_h = require "highscores"

--start the physical simulation
physics.start()
--physics.setDrawMode("hybrid")

local shield_generators = {}
table.insert( shield_generators, shield:new(display.contentWidth / 2, display.contentHeight / 2 + 200 ,50,25,50) )
table.insert( shield_generators, shield:new(50, 400 ,200,50,50) )
table.insert( shield_generators, shield:new(350, 400 ,150,50,50) )
table.insert( shield_generators, shield:new(550, 500 ,70,50,50) )
table.insert( shield_generators, shield:new(750, 500 ,90,50,50) )
table.insert( shield_generators, shield:new(950, 500 ,100,50,50) )

platform:new(256, 64)
ground:new(0, 386)


--[[Corona automatically translates between the screen units and the
internal metric units of the physical simulation
Default ration is 30 pixels == 1 meter. Change with physics.setScale()

To remain consistent with the rest of the SDK, all angular values
are expressed in degrees, +y is down, shape definitions must
declare their points in clockwise order]]

local function onCollide(event)
   if event.phase ~= "began" then
      return
   end

   local collide_shield = {}
   local found_shield = 0
   for i,v in ipairs(shield_generators) do
      if event.object1 == v.image or event.object2 == v.image then
         collide_shield = v
         found_shield = i
      end
   end

   local collide_meteor = {}
   local found_meteor = 0
   for i,v in ipairs(meteor_list) do
      if event.object1 == v.image or event.object2 == v.image then
         collide_meteor = v
         found_meteor = i
      end
   end


   if found_shield ~= 0 and found_meteor ~= 0 then
      collide_shield:take_damage(5)
      meteor_disperse(found_meteor, meteor_list)
      cull_shields(shield_generators)
   elseif found_meteor ~= 0 then
      meteor_disperse(found_meteor, meteor_list)
   end
end

function onFrame(event)
	if platform.instance then
		platform.instance:update(event.time)
	end
end

--add event listeners for other functions
--circle:addEventListener("touch", circleTouch)
--Runtime:addEventListener("enterFrame", penguinFly)
Runtime:addEventListener("collision", onCollide)
Runtime:addEventListener("enterFrame", onFrame)

local high_scores = highscores:new()
high_scores:show_overlay()
--high_scores:kill_overlay()
local high_scores_closure = function()
                               high_scores:kill_overlay()
                            end
timer.performWithDelay(1000, high_scores_closure)

table.insert(survivor_list, survivor:new(500,50) )
local sysFonts = native.getFontNames()
for k,v in pairs(sysFonts) do print(v) end
