physics = require "physics"
meteor = {}

function meteor:new(center_x, center_y, radius, x_velocity, y_velocity)
   local object = {center_x = center_x, center_y = center_y, radius = radius }
   setmetatable(object, { __index = meteor })
   object.image = display.newCircle(center_x, center_y, radius)
   object.type = "live_meteor"
   physics.addBody(object.image, { density = 1.0, friction = 0.3, bounce = 0.2, radius = radius, filter = { categoryBits = 4, maskBits = 57 }})
   object.image:setLinearVelocity(x_velocity, y_velocity)
   object.image:setFillColor(255,0,0)
   return object
end

function shield_collide(event)
   event.object1:take_damage(5)
   print("Shield Damaged")
end

function meteor_disperse(meteor_index, meteor_list)
   local debris_list = {}
   local current_meteor = meteor_list[meteor_index]
   for i=1,10,1 do
      local current = display.newCircle(current_meteor.image.x + math.random(10), current_meteor.image.y + math.random(10), math.random(1,2))
      current:setFillColor(255,255,0)
      
      transition.to(current, {time=500, alpha = 0} )
      
      local vx, vy = current_meteor.image:getLinearVelocity()
      local closure = function()
                         physics.addBody(current, { density = 0.1, friction = 0, bounce = 0.2, radius = 1, filter = { categoryBits = 64, maskBits = 113 }})
                         local x_addition = math.random(50,100)
                         local x_multiplier = math.random(-1,1)
                         if x_multiplier < 0 then
                            x_multiplier = -1
                         else
                            x_multiplier = 1
                         end
                         local y_addition = math.random(50,100)
                         local y_multiplier = math.random(-1,1)
                         if y_multiplier < 0 then
                            y_multiplier = -1
                         else
                            y_multiplier = 1
                         end
                         x_addition = x_addition * x_multiplier
                         y_addition = y_addition * y_multiplier
                         return current:setLinearVelocity(vx*1 + x_addition, vy*-1 + y_addition)
                      end
      timer.performWithDelay(10, closure)
      --physics.addBody(current, { density = 1.0, friction = 0, bounce = 0.2, radius = radius})
      table.insert(debris_list, current)
   end
   local closure2 = function() cull_debris(debris_list) end
   timer.performWithDelay(510, closure2) --not using onComplete in order to limit to a single call
   display.remove(current_meteor.image)
   table.remove(meteor_list, meteor_index)
end

function cull_debris(debris_list)
   local i = #debris_list
   while i > 0 do
      v = debris_list[i]
      --local closure = function() return display.remove(v) end
      --timer.performWithDelay(10, closure)
      display.remove(v)
      --table.remove(debris_list, i)
      i = i - 1
   end
end