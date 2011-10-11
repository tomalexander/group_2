physics = require "physics"
sprite = require "sprite"

resource = {
	-- Class constants
	spriteName = 'img/resource.png',
	spriteWidth = 82,
	spriteHeight = 74,
	spriteIdleFrameBegin = 1,
	spriteIdleFrameCount = 1,
	spriteIdleFrameRate = 1,
	
	group = display.newGroup(),
	
	list = {}
}
resource.spriteSheet = sprite.newSpriteSheet(resource.spriteName, resource.spriteWidth, resource.spriteHeight)
resource.spriteSet = sprite.newSpriteSet(resource.spriteSheet, resource.spriteIdleFrameBegin, resource.spriteIdleFrameCount)

sprite.add(resource.spriteSet, 'idle', resource.spriteIdleFrameBegin, resource.spriteIdleFrameCount, resource.spriteIdleFrameRate, 0)

function resource:new(x, y)
	local object = {
		image = sprite.newSprite(resource.spriteSet),
		
		destroyed = false
	}
	setmetatable(object, { __index = resource })
	
	resource.group:insert(object.image)
	
	physics.addBody(object.image, 'static', {friction = 0.0, bounce = 0.0})
	object.image.isFixedRotation = true
	
	object.image:prepare('idle')
	object.image:play()
	
	object.image.x = x + resource.spriteWidth / 2
	object.image.y = y + resource.spriteHeight / 2
	
	table.insert(resource.list, object)
	
	return object
end

function resource:destroy()
	if not self.destroyed then
		self.image:removeSelf()
		
		-- Remove from resource.list
		
		self.destroyed = true
	end
end
