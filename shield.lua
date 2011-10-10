physics = require "physics"
shield = {}

function shield:new(center_x,center_y, radius, health, max_health)
   local object = { center_x = center_x, center_y = center_y, radius = radius, health = health, max_health = max_health }
   setmetatable(object, { __index = shield })
   object.image = display.newCircle(center_x, center_y, radius)
   object.generator_image = display.newRect(center_x-5, center_y-5, 10,10)
   object:update_color()
   object.type = "shield"
   physics.addBody(object.generator_image, "dynamic", {density = 2000, bounce = 0.0, friction = 1.0, filter = { categoryBits = 2, maskBits = 32 }})
   physics.addBody(object.image, "dynamic", {density = 20, bounce = 0.2, radius = radius, filter = { categoryBits = 1, maskBits = 4 }})
   object.joint = physics.newJoint("pivot", object.generator_image, object.image, center_x, center_y)
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
         display.remove(v.generator_image)
         table.remove(shield_generators, i)
      end
      i = i - 1
   end
end