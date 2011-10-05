physics = require "physics"
sprite = require "sprite"

platform = {
	-- Class constants
	spriteName = 'img/platform.png',
	spriteWidth = 200,
	spriteHeight = 100,
	spriteIdleFrameBegin = 1,
	spriteIdleFrameCount = 1,
	spriteIdleFrameRate = 250,
	velocityMax = 250,
	
	
	-- Make the class singleton-ish so it can handle global events gracefully
	instance = nil
}
platform.spriteSheet = sprite.newSpriteSheet(platform.spriteName, platform.spriteWidth, platform.spriteHeight)
platform.spriteSet = sprite.newSpriteSet(platform.spriteSheet, platform.spriteIdleFrameBegin, platform.spriteIdleFrameCount)

sprite.add(platform.spriteSet, 'idle', platform.spriteIdleFrameBegin, platform.spriteIdleFrameCount, platform.spriteIdleFrameRate, 0)

function platform:new(center_x, center_y)
	if not platform.instance then
		platform.instance = {
			resources = 0,
			destroyed = false,
			image = sprite.newSprite(platform.spriteSet)
		}
		setmetatable(platform.instance, { __index = platform })
		
		physics.addBody(platform.instance.image, 'kinematic', {friction = 0.5, bounce = 0.2})
		platform.instance.image.isFixedRotation = true
		
		Runtime:addEventListener('accelerometer', platform.onAccelerometer)
		Runtime:addEventListener('touch', platform.onTouch)
		platform.instance.image:prepare('idle')
		platform.instance.image:play()
	end
	
	platform.instance.image.x = center_x
	platform.instance.image.y = center_y
	
	return platform.instance
end

function platform:destroy()
	if not destroyed then
		image:removeSelf()
		Runtime:removeEventListener('accelerometer', onAccelerometer)
		Runtime:removeEventListener('touch', onTouch)
		instance = nil
		
		destroyed = true
	end
end

function platform.onAccelerometer(event)
	if platform.instance then
		print('x/y/z: ' .. event.xGravity .. '/' .. event.yGravity .. '/' .. event.zGravity)
	end
end

function platform.onTouch(event)
	-- Can't test accelerometer on simulator, so touch the sides of the screen for testing
	if platform.instance then
		if event.phase == 'began' then
			if event.x < 100 then
				platform.instance.image:setLinearVelocity(-platform.instance.velocityMax, 0)
			elseif event.x > 960 - 100 then
				platform.instance.image:setLinearVelocity(platform.instance.velocityMax, 0)
			end
		elseif event.phase == 'ended' or event.phase == 'cancelled' then
			platform.instance.image:setLinearVelocity(0, 0)
		end
	end
end