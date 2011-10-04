physics = require "physics"
meteor = {}

function meteor:new(center_x, center_y, radius)
   local object = {center_x = center_x, center_y = center_y, radius = radius }
   setmetatable(object, { __index = meteor })
   object.image = display.newCircle(center_x, center_y, radius)
   object.image:setFillColor(255,0,0)
   object.type = "live_meteor"
   physics.addBody(object.image, { density = 1.0, friction = 0.3, bounce = 0.2, radius = radius})
   return object
end

function shield_collide(event)
   event.object1:take_damage(5)
   print("Shield Damaged")
end