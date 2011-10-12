physics = require "physics"
local http = require("socket.http")
url = require("socket.url")
 

 
highscores = {}

function highscores:new()
   local object = {}
   object.parsed_scores = {}
   setmetatable(object, { __index = highscores })
   return object
end

function highscores:parse_scores(input)
   local new_parsed_scores = {}
   local lines = split(input, "\n")
   for i,line in ipairs(lines) do
      if line ~= {} then
         sections = split(line, ",")
         table.insert(new_parsed_scores, sections)
      end
   end
   self.parsed_scores = new_parsed_scores
end

function highscores:display_name_box()
   self.input_field = native.newTextField( 50, 150, 500, 360, high_scores_listener)
   self.input_field.text = "Enter Name"
end

function high_scores_listener(event)
   if (event.phase == "began") then
      if (high_scores.input_field.text == "Enter Name") then
         high_scores.input_field.text = ""
      end
   elseif (event.phase == "submitted") then
      self:insert_score(high_scores.input_field.text, 9999)
      high_scores.input_field:removeSelf()
   end
end

function highscores:insert_score(name, score)
   local high_scores = http.request("http://gamedevhighscores.paphus.com/?newscore=" .. url.escape(score) .. "&newname=" .. url.escape(name))
   self:parse_scores(high_scores)
end

function highscores:update_scores()
   local high_scores = http.request("http://gamedevhighscores.paphus.com/")
   self:parse_scores(high_scores)
end

function highscores:print_scores()
   for i,line in ipairs(self.parsed_scores) do
      print(line[1] .. " " .. line[2])
   end
end

function highscores:show_overlay()
   self.overlay = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
   self.overlay:setFillColor( 0,0,0,200 )
   self.overlay:addEventListener( "touch", doOverlay )
   self:generate_highscores()
end

function highscores:kill_overlay()
   print("killing overlay")
   self.overlay:removeEventListener( "touch", doOverlay )
   self.overlay:removeSelf()
   self.score_group:removeSelf()
   self.overlay = nil
end

function highscores:generate_highscores()
   local x = 300
   local y = 100
   local margin = 40
   self:update_scores()
   self.score_group = display.newGroup()
   local headline_text = display.newText("High Scores", x-20, y - 60, "Space Frigate", 54)
   self.score_group:insert(headline_text)
   for i, line in ipairs(self.parsed_scores) do
         local current_text = display.newText(line[1] .. " " .. line[2], x, y, "Space Frigate", 44)
         y = y + margin
         current_text:setTextColor(255, 255, 255)
         self.score_group:insert(current_text)
   end
end

function doOverlay()
    return true
end

function split(input, seperator)
   local previous_end = 1
   local ret = {}
   if input:len() == 0 then
      return ret
   end
   for i=1,input:len() do
      if input:sub(i,i) == seperator then
         table.insert(ret, input:sub(previous_end, i-1))
         previous_end = i+1
      end
   end
   if previous_end < input:len() then
      table.insert(ret, input:sub(previous_end))
   end
   return ret
end
