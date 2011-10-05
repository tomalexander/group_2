physics = require "physics"
sprite = require "sprite"
require "resource"

ground = {
	-- Class constants
	spriteName = 'img/ground.png',
	spriteWidth = 16,
	spriteHeight = 16,
	spriteIdleFrameBegin = 1,
	spriteIdleFrameCount = 1,
	spriteIdleFrameRate = 1,
	
	-- Each tile's probability of spawning a resource on it
	resourceProbability = 0.01,
	
	list = {}
}
ground.spriteSheet = sprite.newSpriteSheet(ground.spriteName, ground.spriteWidth, ground.spriteHeight)
ground.spriteSet = sprite.newSpriteSet(ground.spriteSheet, ground.spriteIdleFrameBegin, ground.spriteIdleFrameCount)

sprite.add(ground.spriteSet, 'idle', ground.spriteIdleFrameBegin, ground.spriteIdleFrameCount, ground.spriteIdleFrameRate, 0)

function ground:new(x, y)
	local object = {
		destroyed = false,
		image = sprite.newSprite(ground.spriteSet)
	}
	setmetatable(object, { __index = ground })
	
	physics.addBody(object.image, 'static', {friction = 0.6, bounce = 0.4})
	object.image.isFixedRotation = true
	
	object.image:prepare('idle')
	object.image:play()
	
	object.image.x = x
	object.image.y = y
	
	table.insert(ground.list, object)
	
	return object
end

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

function ground:destroy()
	if not destroyed then
		image:removeSelf()
		
		-- Remove from ground.list
		
		destroyed = true
	end
end
