meteor_h = require "meteor"

meteor_list = {}

function generate_meteor( event )
	table.insert(meteor_list, meteor:new(platform.instance.image.x + math.random(-500,500),0	,10, math.random(-500,500), math.random(250,500)))
end

function off_screen_generate_meteor( event )
   for i,v in ipairs(meteor_spawn_list) do
      --print("Meteors in " .. v)
      table.insert(meteor_list, meteor:new(v+500 + math.random(-500,500),0,10, math.random(-500,500), math.random(250,500)))
   end
end

meteor_generator_timer = timer.performWithDelay(250, generate_meteor, 0)
meteor_generator_timer = timer.performWithDelay(750, off_screen_generate_meteor, 0)


function cull_meteor()
   local cull_list = {}
   for i = #meteor_list,1,-1 do --Iterate backwards
      v = meteor_list[i]
      if v.type == "dead_meteor" or v.image.y > display.contentHeight then
         cull_list.insert(i)
      end
   end
   for i,v in ipairs(cull_list) do
      display.remove(v.image)
      tables.remove(meteor_list, v)
   end
end

meteor_spawn_list = {}
table.insert(meteor_spawn_list, 0)