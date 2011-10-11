physics = require "physics"
require "sprite"
shield = {}

shield_sprite_sheet = sprite.newSpriteSheet("img/generator_shield.jpg", 335, 176)
shield_sprite_set = sprite.newSpriteSet(shield_sprite_sheet, 1, 7)
sprite.add(shield_sprite_set, 'idle', 1, 7, 500, 0)

function shield:new(center_x,center_y, radius, health, max_health)
   local object = { center_x = center_x, center_y = center_y, radius = radius, health = health, max_health = max_health }
   setmetatable(object, { __index = shield })
   
   object.image = sprite.newSprite(shield_sprite_set)
   object.image.x = center_x
   object.image.y = center_y
   object.image.width = radius
   object.image.height = radius
   --object.image = display.newCircle(center_x, center_y, radius)
   object.generator_image = display.newRect(center_x-5, center_y-5, 10,10)
   object.generator_image.isVisible = false
   object:update_color()
   object.type = "shield"
   physics.addBody(object.generator_image, "dynamic", {density = 2000, bounce = 0.0, friction = 1.0, filter = { categoryBits = 2, maskBits = 32 }})
   physics.addBody(object.image, "dynamic", {density = 20, bounce = 0.2, radius = radius, filter = { categoryBits = 1, maskBits = 70 }})
   object.joint = physics.newJoint("pivot", object.generator_image, object.image, center_x, center_y)
   object.image:prepare('idle')
   object.image:play()
   return object
end

function shield:update_color()
   --self.image:setFillColor(51,204,255 , 255 * self.health / self.max_health)
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

function gen_new_generator(event)
   if event.phase == "began" and event.y < display.contentHeight/20 and event.x > display.contentWidth/10 and event.x < display.contentWidth*9/10 then
      table.insert( shield_generators, shield:new(event.x, event.y, 150, 50, 50) )
   end
end

Runtime:addEventListener("touch", gen_new_generator)