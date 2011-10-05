physics = require "physics"
sprite = require "sprite"
--event = require "event"

platform = {
	-- Class constants
	spriteName = 'img/platform.png',
	spriteWidth = 200,
	spriteHeight = 100,
	spriteIdleFrameBegin = 1,
	spriteIdleFrameCount = 1,
	spriteIdleFrameRate = 250,
	velocityMax = 250,
	
	
	
	instance = nil
}
platform.spriteSheet = sprite.newSpriteSheet(platform.spriteName, platform.spriteWidth, platform.spriteHeight)
platform.spriteSet = sprite.newSpriteSet(platform.spriteSheet, platform.spriteIdleFrameBegin, platform.spriteIdleFrameCount)

sprite.add(platform.spriteSet, 'idle', platform.spriteIdleFrameBegin, platform.spriteIdleFrameCount, platform.spriteIdleFrameRate, 0)

function platform:new(center_x, center_y)
	if not instance then
		instance = {
			velocity = 0,
			resources = 0,
			destroyed = false,
			image = sprite.newSprite(platform.spriteSet)
		}
		setmetatable(instance, { __index = platform })
		
		--instance.body = physics.addBody(instance.image, 'static', {density = 0, friction = 0.5, bounce = 0.2})
		physics.addBody(instance.image, 'kinematic', {friction = 0.5, bounce = 0.2})
		instance.image.isFixedRotation = true
		
		Runtime:addEventListener('accelerometer', platform.onAccelerometer)
		Runtime:addEventListener('touch', platform.onTouch)
		instance.image:prepare('idle')
		instance.image:play()
	end
	
	instance.image.x = center_x
	instance.image.y = center_y
	
	return instance
end

function platform:destroy()
	if not destroyed then
		body:removeSelf()
		Runtime:removeEventListener('accelerometer', onAccelerometer)
		Runtime:removeEventListener('touch', onTouch)
		instance = nil
		
		destroyed = true
	end
end

function platform.onAccelerometer(event)
	if instance then
		print('x/y/z: ' .. event.xGravity .. '/' .. event.yGravity .. '/' .. event.zGravity)
	end
end

function platform.onTouch(event)
	-- Can't test accelerometer on simulator, so touch the sides of the screen for testing
	if instance then
		if event.phase == 'began' then
			if event.x < 100 then
				instance.image:setLinearVelocity(-instance.velocityMax, 0)
			elseif event.x > 960 - 100 then
				instance.image:setLinearVelocity(instance.velocityMax, 0)
			end
		elseif event.phase == 'ended' or event.phase == 'cancelled' then
			instance.image:setLinearVelocity(0, 0)
		end
	end
end
