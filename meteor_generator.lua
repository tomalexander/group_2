meteor_h = require "meteor"

meteor_list = {}

function generate_meteor( event )
   table.insert(meteor_list, meteor:new(math.random(display.contentWidth),0,10, math.random(-500,500), math.random(250,500)))
end

meteor_generator_timer = timer.performWithDelay(1000, generate_meteor, 0)

function cull_meteor()
   local cull_list = {}
   for i = #meteor_list,1,-1 do --Iterate backwards
      v = meteor_list[i]
      if v.type == "dead_meteor" then
         cull_list.insert(i)
      end
   end
   for i,v in ipairs(cull_list) do
      tables.remove(meteor_list, v)
   end
end