physics = require "physics"
shield = {}

function shield:new(center_x,center_y, radius, health, max_health)
   local object = { center_x = center_x, center_y = center_y, radius = radius, health = health, max_health = max_health }
   setmetatable(object, { __index = shield })
   object.image = display.newCircle(center_x, center_y, radius)
   object:update_color()
   object.type = "shield"
   physics.addBody(object.image, "static", {bounce = 0.7, radius = radius})
   return object
end

function shield:update_color()
   self.image:setFillColor(51,204,255 , 255 * self.health / self.max_health)
end

function shield:take_damage(damage)
   self.health = self.health - damage
   if self.health < 0 then
      self.health = 0
   end
   self:update_color()
end

function cull_shields(shield_generators)
   local i = #shield_generators
   while i > 0 do
      v = shield_generators[i]
      if v.health == 0 then
         --local closure = function() return display.remove(v.image) end
         --timer.performWithDelay(10, closure)
         display.remove(v.image)
         table.remove(shield_generators, i)
      end
      i = i - 1
   end
end