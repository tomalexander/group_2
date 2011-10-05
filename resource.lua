physics = require "physics"
sprite = require "sprite"

resource = {
	-- Class constants
	spriteName = 'img/resource.png',
	spriteWidth = 32,
	spriteHeight = 32,
	spriteIdleFrameBegin = 1,
	spriteIdleFrameCount = 1,
	spriteIdleFrameRate = 1,
	
	list = {}
}
resource.spriteSheet = sprite.newSpriteSheet(resource.spriteName, resource.spriteWidth, resource.spriteHeight)
resource.spriteSet = sprite.newSpriteSet(resource.spriteSheet, resource.spriteIdleFrameBegin, resource.spriteIdleFrameCount)

sprite.add(resource.spriteSet, 'idle', resource.spriteIdleFrameBegin, resource.spriteIdleFrameCount, resource.spriteIdleFrameRate, 0)

function resource:new(x, y)
	local object = {
		destroyed = false,
		image = sprite.newSprite(resource.spriteSet)
	}
	setmetatable(object, { __index = resource })
	
	physics.addBody(object.image, 'static', {friction = 0.0, bounce = 0.0})
	object.image.isFixedRotation = true
	
	object.image:prepare('idle')
	object.image:play()
	
	object.image.x = x
	object.image.y = y
	
	table.insert(resource.list, object)
	
	return object
end

function resource:destroy()
	if not destroyed then
		image:removeSelf()
		
		-- Remove from resource.list
		
		destroyed = true
	end
end
