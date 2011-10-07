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
		w = w or ground.spriteWidth,
		h = h or ground.spriteHeight,
		
		destroyed = false
	}
	setmetatable(object, { __index = ground })
	if w or h then
		object:resize(x, y, object.w, object.h)
	else
		object.sheet = ground.spriteSheet
		object.set = ground.spriteSet
		object.image = sprite.newSprite(object.set)
		physics.addBody(object.image, 'static', {friction = 0.6, bounce = 0.4})
		
		object.image.x = round(x + object.w / 2)
		object.image.y = round(y + ground.spriteHeight / 2)
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
	return round(self.image.x) - self.w / 2
end

function ground:y()
	return round(self.image.y) - self.h / 2
end

function ground:resize(x, y, w, h)
	
	if self.image then
		self.image:removeSelf()
	end
	print('Resize:')
	print(x % ground.spriteWidth)
	print(ground.spriteHeight - (h or ground.spriteHeight))
	print(w or ground.spriteWidth)
	print(h or ground.spriteHeight)
	print('---')
	
	-- If creating a partial ground, create a sprite sheet from the remaining area
	local function createData()
		local data = 
		{
			frames = 
			{
				{
				name = ground.spriteName,
				textureRect = {
					x = x % ground.spriteWidth,
					y = ground.spriteHeight - (h or ground.spriteHeight),
					width = w or ground.spriteWidth,
					height = h or ground.spriteHeight
				},
				spriteTrimmed = true,
				spriteColorRect = {
					x = 0,
					y = 0,
					width = w or ground.spriteWidth,
					height = h or ground.spriteHeight
				},
				spriteSourceSize = {
					width = w or ground.spriteWidth,
					height = h or ground.spriteHeight
				},
				},
			}
		}
		return data
	end
	
	self.sheet = sprite.newSpriteSheetFromData(ground.spriteName, createData())
	self.set = sprite.newSpriteSet(self.sheet, ground.spriteIdleFrameBegin, ground.spriteIdleFrameCount)
	sprite.add(self.set, 'idle', ground.spriteIdleFrameBegin, ground.spriteIdleFrameCount, ground.spriteIdleFrameRate, 0)
	self.image = sprite.newSprite(self.set)
	
	self.w = w
	self.h = h
	print(x .. ' ' .. y .. ' ' .. self.w .. ' ' .. self.h)
	self.image.x = round(x + self.w / 2)
	self.image.y = round(y + self.h / 2)
	
	print(self.image.x .. ' ' .. self.image.y .. ' ' .. self.w .. ' ' .. self.h)
	
	physics.addBody(self.image, 'static', {friction = 0.6, bounce = 0.4})
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
		self:resize(left, self:y() + pixels, right - left, self.h - pixels)
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
		self.image:removeSelf()
		
		-- Remove from ground.list
		
		self.destroyed = true
	end
end
