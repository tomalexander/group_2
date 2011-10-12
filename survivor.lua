physics = require "physics"
platform_h = require "platform"
require "sprite"
survivor = {}

survivor_sprite_sheet = sprite.newSpriteSheet("img/colonist.png", 59, 66)
survivor_sprite_set = sprite.newSpriteSet(survivor_sprite_sheet, 1, 16)
sprite.add(survivor_sprite_set, 'idle_facing_right', 8,1,500,0)
sprite.add(survivor_sprite_set, 'idle_facing_left', 16,1,500,0)
sprite.add(survivor_sprite_set, 'run_right', 1,8,1500,0)
sprite.add(survivor_sprite_set, 'run_left', 9,8,1500,0)


function survivor:new(x_location, y_location)
   local object = {x_location = x_location, y_location = y_location, platform_reference = platform.instance, x_direction = 0}
   setmetatable(object, { __index = survivor })
   object.image = sprite.newSprite(survivor_sprite_set)
   object.image.x = x_location
   object.image.y = y_location
   object.type = "survivor"
   physics.addBody(object.image, {friction = 0.0, bounce = 0.2, filter = { categoryBits = 8, maskBits = 4 }})
   object.image.bodyType = "kinematic"
   object.image:addEventListener( "touch", object )
   object.image:prepare('idle_facing_left')
   object.image:play()
   return object
end

function survivor:touch(event)
   print("Erry day im touching")
   if event.phase ~= "ended" then
      return true --Not useful
   end
   self:begin_run()
   return true
end

function survivor:begin_run()
   media.playEventSound(sound.survivor_run)
   if (extractionPoint.x < self.image.x) then
      self.x_direction = -1
      self.image:prepare('run_left')
      self.image:play()
   else
      self.x_direction = 1
      self.image:prepare('run_right')
      self.image:play()
   end
   self.image:setLinearVelocity(200*self.x_direction, 0)
end


survivor_list = {}

function random_create_survivor(x_position, xprev)
   local i = 0
   print("ground " .. x_position .. " " .. xprev)
   -- Going right, xpos > xprev
   local lookahead = 960
   if x_position < xprev then
      lookahead = lookahead * -1 - 960
   end
   while i < 5 do
      chance = math.random(1,2)
      if (chance == 1) then
         table.insert(survivor_list, survivor:new(math.random(-400,400) + x_position + 960 + lookahead, 450))
      end
      i = i + 1
   end
end

function check_for_survivors()
   local i = #survivor_list
   while i > 0 do
      current = survivor_list[i]
      distance = math.abs(extractionPoint.x - current.image.x)
      --distance = get_distance(platform.instance.image.x, platform.instance.image.y, current.image.x, current.image.y)
      if (distance < 50) then
         display.remove(current.image)
         table.remove(survivor_list, i)
         hud:increaseScore()
		 media.playEventSound(sound.survivor_escape)
      end

      i = i -1
   end
end

survivor_check_timer = timer.performWithDelay(100, check_for_survivors, 0)

function get_distance(x_1, y_1, x_2, y_2)
   local x = x_1 - x_2
   x = x * x
   local y = y_1 - y_2
   y = y * y
   return math.sqrt(x+y)
end

function kill_survivor(survivor_index, survivor_list)
   print("removing survivor")
   display.remove(survivor_list[survivor_index].image)
   table.remove(survivor_list, survivor_index)
end