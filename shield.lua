physics = require "physics"
shield = {}

function shield:new(center_x,center_y, radius, health, max_health)
   local object = { center_x = center_x, center_y = center_y, radius = radius, health = health, max_health = max_health }
   setmetatable(object, { __index = shield })
   object.image = display.newCircle(center_x, center_y, radius)
   object:update_color()
   physics.addBody(object.image, "static", {bounce = 0.7, radius = radius})
   return object
end

function shield:update_color()
   self.image:setFillColor(51,204,255 , 255 * self.health / self.max_health)
end

function shield:take_damage(damage)
   self.health = self.health - damage
end