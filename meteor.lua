physics = require "physics"
meteor = {}

meteor_sprite_sheet = sprite.newSpriteSheet("img/meteor.png", 26, 26)
tail_sprite_sheet = sprite.newSpriteSheet("img/meteor_tail.png", 36, 149)
tail_sprite_set = sprite.newSpriteSet(tail_sprite_sheet, 1, 4)
sprite.add(tail_sprite_set, 'idle', 1, 4, 50, 0)

function meteor:new(center_x, center_y, radius, x_velocity, y_velocity)
   local object = {center_x = center_x, center_y = center_y, radius = radius }
   setmetatable(object, { __index = meteor })
   object.sprite_sheet = sprite.newSpriteSet(meteor_sprite_sheet, math.random(9), 1)
   object.tail = sprite.newSprite(tail_sprite_set)
   object.tail.x = center_x
   object.tail.y = center_y - 50
   object.image = sprite.newSprite(object.sprite_sheet)
   object.image.x = center_x
   object.image.y = center_y
   object.type = "live_meteor"
   physics.addBody(object.image, { density = 1.0, friction = 0.3, bounce = 0.2, radius = radius, filter = { categoryBits = 4, maskBits = 57 }})
   physics.addBody(object.tail, {density = 0.0001, bounce = 0.2})
   object.tail.isFixedRotation = true
   object.joint = physics.newJoint("weld", object.tail, object.image, center_x, center_y)
   object.image:setLinearVelocity(x_velocity, y_velocity)
   local max_x_velocity = 500
   object.tail:rotate(x_velocity / max_x_velocity * -45)
   print(x_velocity)
   object.tail:prepare('idle')
   object.tail:play()
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
   display.remove(current_meteor.tail)
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