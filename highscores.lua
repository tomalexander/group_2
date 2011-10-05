physics = require "physics"
local http = require("socket.http")
 

 
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

function highscores:insert_scores(name, score)
   local high_scores = http.request("http://gamedevhighscores.paphus.com/?newscore=" .. score .. "&newname=" .. name)
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