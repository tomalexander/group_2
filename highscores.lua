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
   self.input_window = display.newRect( 40, 140, 820, 220)
   self.input_window:setFillColor(0,0,0)
   self.input_field = native.newTextField( 50, 150, 400, 200, high_scores_listener)
   self.input_box = display.newRect(475, 150, 300, 60)
   self.input_box:setFillColor(128,128,128)
   self.input_box_text = display.newText("Submit", 485, 150, "Space Frigate", 54)
   exit_your_god_damn_closure = function()
                                   os.exit()
                                end
   high_scores_show_overlay = function()
                                 high_scores:show_overlay()
                              end
   high_scores_submit = function()
                           high_scores:insert_score(high_scores.input_field.text, hud.score)
                           high_scores.input_field:removeSelf()
                           high_scores.input_box:removeSelf()
                           high_scores.input_box_text:removeSelf()
                           high_scores.input_window:removeSelf()
                           --timer.performWithDelay(10, high_scores_show_overlay)
                           --high_scores:show_overlay()
                           tempory_high_scores(15000)
                           timer.performWithDelay(15000, exit_your_god_damn_closure)
                           return true
                        end
   self.input_box:addEventListener( "touch", high_scores_submit )
   self.input_field.text = "Enter Name"
end

function high_scores_listener(event)
   if (event.phase == "began") then
      if (high_scores.input_field.text == "Enter Name") then
         high_scores.input_field.text = ""
      end
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
   high_scores:kill_overlay()
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

high_scores = highscores:new()

function tempory_high_scores(duration)
   kill_temp_high_scores = function()
                              high_scores:kill_overlay()
                           end

   timer.performWithDelay(duration, kill_temp_high_scores)
   high_scores:show_overlay()
   high_scores.overlay:removeEventListener( "touch", doOverlay )
end