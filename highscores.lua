physics = require "physics"
local http = require("socket.http")
 
local high_scores = http.request{
    url = "http://gamedevhighscores.paphus.com/"
}
print(high_scores)
 
highscores = {}

function highscores:new()
end