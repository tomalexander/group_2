physics = require "physics"
sprite = require "sprite"
--require "resource"

local round = function(n)
	if n >= 0 then
		return math.floor(n + 0.5)
	end
	
	return math.ceil(n - 0.5)
end

ground = {
	-- Class constants
	spriteName = 'img/ground.png',
	spriteWidth = 1000,
	spriteHeight = 90,
	spriteIdleFrameBegin = 1,
	spriteIdleFrameCount = 1,
	spriteIdleFrameRate = 1,
	
	-- The chance of a resource spawning per width pixel
	resourceChance = 0.0021, -- Approximately 2 resources per 1000 pixels (1 ground object)
	
	partitions = {},
	
	group = display.newGroup(),
	list = {}
}
ground.spriteSheet = sprite.newSpriteSheet(ground.spriteName, ground.spriteWidth, ground.spriteHeight)
ground.spriteSet = sprite.newSpriteSet(ground.spriteSheet, ground.spriteIdleFrameBegin, ground.spriteIdleFrameCount)

sprite.add(ground.spriteSet, 'idle', ground.spriteIdleFrameBegin, ground.spriteIdleFrameCount, ground.spriteIdleFrameRate, 0)

function ground.scroll(x, xprev)
	-- whenever the screen moves, call ground.scroll with x as the effective x coordinate,
	-- and xprev as the screen's effective x coordinate before moving
	local partnum = math.floor(x / 960)
	if ground.partitions[partnum] then
		for _, i in ipairs(ground.partitions[partnum]) do
			i:load()
		end
	else
		ground.partitions[partnum] = {ground:new(x, 450)}
	end
	if ground.partitions[partnum + 1] then
		for _, i in ipairs(ground.partitions[partnum + 1]) do
			i:load()
		end
	else
		ground.partitions[partnum + 1] = {ground:new(x, 450)}
	end
	
	local partnumprev = math.floor(xprev / 960)
	if partnumprev ~= partnum or partnumprev ~= partnum + 1 then
		for _, i in ipairs(ground.partitions[partnumprev]) do
			i:unload()
		end
	end
	if partnumprev + 1 ~= partnum or partnumprev + 1 ~= partnum + 1 then
		for _, i in ipairs(ground.partitions[partnumprev + 1]) do
			i:unload()
		end
	end
end	

function ground:new(x, y, w, h)
	local object = {
		-- Set w and h if given, else default to fullsize sprite
		_x = x,
		_y = y,
		w = w or ground.spriteWidth,
		h = h or ground.spriteHeight,
		
		resources = {},
		
		destroyed = false
	}
	setmetatable(object, { __index = ground })
	object:resize(x, y, object.w, object.h)
	
	if not object:isPartial() then	
		-- Have new ground spawn some resources
		--[[
		local count = math.random(1, 3)
		
		for i = 0, count do
			resource:new(x + math.random(0, ground.spriteWidth - resource.spriteWidth), y + math.random(0, ground.spriteHeight - resource.spriteHeight))
		end
		]]
		local pos = 0
		while pos < ground.spriteWidth do
			if math.random() <= self.resourceChance then
				table.insert(object.resources, resource:new(x + pos, y + math.random(0, ground.spriteHeight - resource.spriteHeight)))
				pos = pos + resource.spriteWidth
			end
			pos = pos + 1
		end
	end
	
	
	object.image.isFixedRotation = true
	
	object.image:prepare('idle')
	object.image:play()
	
	
	--object.image.x = round(x)
	--object.image.y = round(y)
	
	table.insert(ground.list, object)
	
	return object
end
-- x() and y() are function calls so that they return the top left, not center
function ground:x()
	return self._x
	--return round(self.image.x) - self.w / 2
end

function ground:y()
	return self._y
	--return round(self.image.y) - self.h / 2
end

function ground:isPartial()
	return self.w ~= ground.spriteWidth or self.h ~= ground.spriteHeight
end

function ground:isLoaded()
	return self.image ~= nil
end

function ground:load()
	if self:isLoaded() then
		return
	end
	-- If creating a partial ground, create a sprite sheet from the remaining area
	if self:isPartial() then
		local function createData()
			local data = 
			{
				frames = 
				{
					{
					name = ground.spriteName,
					textureRect = {
						x = self:x() % ground.spriteWidth,
						y = ground.spriteHeight - (self.h or ground.spriteHeight),
						width = self.w or ground.spriteWidth,
						height = self.h or ground.spriteHeight
					},
					spriteTrimmed = true,
					spriteColorRect = {
						x = 0,
						y = 0,
						width = self.w or ground.spriteWidth,
						height = self.h or ground.spriteHeight
					},
					spriteSourceSize = {
						width = self.w or ground.spriteWidth,
						height = self.h or ground.spriteHeight
					},
					},
				}
			}
			return data
		end
		
		self.sheet = sprite.newSpriteSheetFromData(ground.spriteName, createData())
		self.set = sprite.newSpriteSet(self.sheet, ground.spriteIdleFrameBegin, ground.spriteIdleFrameCount)
		sprite.add(self.set, 'idle', ground.spriteIdleFrameBegin, ground.spriteIdleFrameCount, ground.spriteIdleFrameRate, 0)
	else
		self.sheet = ground.spriteSheet
		self.set = ground.spriteSet
	end
	self.image = sprite.newSprite(self.set)
	ground.group:insert(self.image)
	
	self.image.x = round(self:x() + self.w / 2)
	self.image.y = round(self:y() + self.h / 2)
	
	physics.addBody(self.image, 'static', {friction = 0.6, bounce = 0.4, filter = { categoryBits = 32, maskBits = 71 }})
end

function ground:unload()
	if self.image then
		self.image:removeSelf()
		self.image = nil
	end
end

function ground:resize(x, y, w, h)
	self:unload()
	
	self._x = x
	self._y = y
	self.w = w
	self.h = h
	
	self:load()
end

function ground:carve(x, w, pixels)
	x, w = round(x), round(w)
	
	for _, i in ipairs(self.resources) do
		if self:y() > i.image.y - i.spriteHeight/2 then
			if x > i.image.x - i.spriteHeight/2 and x < i.image.x + i.spriteHeight/2 then
				print('extract!')
				break
			end
		end
	end

	local left, right = math.floor(x - w/2), math.ceil(x + w/2)
	local newleft, newright = self:x(), self:x() + self.w
	-- Break off sides of rectangle if outside of contact width
	if left > self:x() then
		local g = ground:new(self:x(), self:y(), left - self:x(), self.h)
		local l = {}
		for _, i in ipairs(self.resources) do
			if i.image.x > g:x() + g.w then
				table.insert(l, i)
			else
				table.insert(g.resources, i)
			end
		end
		self.resources = l
		print(type(ground.partitions[0]))
		table.insert(ground.partitions[math.floor(g:x()/960)], g)
		newleft = left
	end
	if right < self:x() + self.w then
		local g = ground:new(right, self:y(), self:x() + self.w - right, self.h)
		local l = {}
		for _, i in ipairs(self.resources) do
			if i.image.x < g:x() then
				table.insert(l, i)
			else
				table.insert(g.resources, i)
			end
		end
		self.resources = l
		table.insert(ground.partitions[math.floor(g:x()/960)], g)
		newright = right
	end
	if self.h - pixels <= 0 then
		-- If the entire ground is carved away, just destroy
		self:destroy()
	else
		-- Shrink rectangle directly under contact
		self:resize(newleft, self:y() + pixels, newright - newleft, self.h - pixels)
	end
end

--[[
function ground:newArea(x, y, w, h)
	-- Put all the ground tiles into a group so that they have an earlier draw order than resources
	local group = display.newGroup()
	for i = 0, w, ground.spriteWidth do
		for j = 0, h, ground.spriteHeight do
			local g = ground:new(x + i, y + j)
			group:insert(g.image)
			
			if math.random() <= ground.resourceProbability then
				resource:new(x + i, y + j)
			end
		end
	end
end
--]]

function ground:destroy()
	if not self.destroyed then
		self:unload()
		
		-- Remove from ground.list
		
		self.destroyed = true
	end
end

--ground.partitions[0] = {ground:new(0, 450)}
--ground:new(0, 450)
