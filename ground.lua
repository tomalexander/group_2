physics = require "physics"
sprite = require "sprite"
require "resource"

local round = function(n)
	if n >= 0 then
		return math.floor(n + 0.5)
	end
	
	return math.ceil(n - 0.5)
end

ground = {
	-- Class constants
	spriteName = 'img/ground.png',
	spriteMaskName = 'img/ground_mask.png',
	spriteWidth = 1000,
	spriteHeight = 90,
	spriteIdleFrameBegin = 1,
	spriteIdleFrameCount = 1,
	spriteIdleFrameRate = 1,
	
	-- Each tile's probability of spawning a resource on it
	resourceProbability = 0.01,
	
	group = display.newGroup(),
	list = {}
}
ground.spriteSheet = sprite.newSpriteSheet(ground.spriteName, ground.spriteWidth, ground.spriteHeight)
ground.spriteSet = sprite.newSpriteSet(ground.spriteSheet, ground.spriteIdleFrameBegin, ground.spriteIdleFrameCount)

sprite.add(ground.spriteSet, 'idle', ground.spriteIdleFrameBegin, ground.spriteIdleFrameCount, ground.spriteIdleFrameRate, 0)

function ground:new(x, y, w, h)
	local object = {
		-- Set w and h if given, else default to fullsize sprite
		_x = x,
		_y = y,
		w = w or ground.spriteWidth,
		h = h or ground.spriteHeight,
		
		destroyed = false
	}
	setmetatable(object, { __index = ground })
	object:resize(x, y, object.w, object.h)
	
	if not object:isPartial() then	
		-- Have new ground spawn some resources
		local count = math.random(1, 3)
		
		for i = 0, count do
			resource:new(x + math.random(0, ground.spriteWidth - resource.spriteWidth), y + math.random(0, ground.spriteHeight - resource.spriteHeight))
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

function ground:load()
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
	
	physics.addBody(self.image, 'static', {friction = 0.6, bounce = 0.4, filter = { categoryBits = 32, maskBits = 6 }})
end

function ground:unload()
	if self.image then
		self.image:removeSelf()
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

	local left, right = math.floor(x - w/2), math.ceil(x + w/2)
	local newleft, newright = self:x(), self:x() + self.w
	-- Break off sides of rectangle if outside of contact width
	if left > self:x() then
		ground:new(self:x(), self:y(), left - self:x(), self.h)
		newleft = left
	end
	if right < self:x() + self.w then
		ground:new(right, self:y(), self:x() + self.w - right, self.h)
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
