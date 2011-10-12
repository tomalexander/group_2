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
	spriteDepleteFrameBegin = 2,
	spriteDepleteFrameCount = 1,
	spriteDepleteFrameRate = 1,
	
	group = display.newGroup(),
	
	list = {}
}
resource.spriteSheet = sprite.newSpriteSheet(resource.spriteName, resource.spriteWidth, resource.spriteHeight)
resource.spriteSet = sprite.newSpriteSet(resource.spriteSheet, resource.spriteIdleFrameBegin, resource.spriteIdleFrameCount + resource.spriteDepleteFrameCount)

sprite.add(resource.spriteSet, 'idle', resource.spriteIdleFrameBegin, resource.spriteIdleFrameCount, resource.spriteIdleFrameRate, 0)
sprite.add(resource.spriteSet, 'deplete', resource.spriteDepleteFrameBegin, resource.spriteDepleteFrameCount, resource.spriteDepleteFrameRate, 0)

function resource:new(x, y)
	local object = {
		image = sprite.newSprite(resource.spriteSet),
		
		remaining = 30,
		
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

function resource:extract()
	if self.remaining > 0 then
		self.remaining = self.remaining - 1
		if self.remaining == 0 then
			self.image:prepare('deplete')
			self.image:play()
		end
		
		return 1
	end
	return 0
end

function resource:destroy()
	if not self.destroyed then
		self.image:removeSelf()
		
		-- Remove from resource.list
		
		self.destroyed = true
	end
end
