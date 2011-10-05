survivor = {}

function survivor:new(x_location, y_location)
   local object = {x_location = x_location, y_location = y_location}
   setmetatable(object, { __index = survivor })
   object.image = display.newCircle(x_location, y_location, 3)
   object.type = "survivor"
   object.image:setFillColor(0,255,0)
   return object
end