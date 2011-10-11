physics = require "physics"
platform_h = require "platform"
survivor = {}

function survivor:new(x_location, y_location)
   local object = {x_location = x_location, y_location = y_location, platform_reference = platform.instance, x_direction = 0}
   setmetatable(object, { __index = survivor })
   object.image = display.newCircle(x_location, y_location, 3)
   object.type = "survivor"
   object.image:setFillColor(0,255,0)
   physics.addBody(object.image, {friction = 0.0, bounce = 0.2, filter = { categoryBits = 8, maskBits = 4 }})
   object.image.bodyType = "kinematic"
   object.image:addEventListener( "touch", object )
   return object
end

function survivor:touch(event)
   if event.phase ~= "ended" then
      return false --Not useful
   end
   self:begin_run()
   return true
end

function survivor:begin_run()
   if (self.platform_reference.image.x < self.image.x) then
      self.x_direction = -1
   else
      self.x_direction = 1
   end
   self.image:setLinearVelocity(200*self.x_direction, 0)
end


survivor_list = {}

function check_for_survivors()
   local i = #survivor_list
   while i > 0 do
      current = survivor_list[i]

      distance = get_distance(platform.instance.image.x, platform.instance.image.y, current.image.x, current.image.y)
      if (distance < 50) then
         display.remove(current.image)
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