physics = require "physics"
sprite = require "sprite"
require 'ground'

platform = {
	-- Class constants
	spriteName = 'img/platform.png',
	spriteWidth = 199,
	spriteHeight = 103,
	spriteIdleFrameBegin = 1,
	spriteIdleFrameCount = 1,
	spriteIdleFrameRate = 500,
	spriteFireFrameBegin = 2,
	spriteFireFrameCount = 3,
	spriteFireFrameRate = 500,
	velocityMax = 250,
	
	charge = 0,
	chargeFull = 30,
	
	-- Make the class singleton-ish so it can handle global events gracefully
	instance = nil
}
platform.spriteSheet = sprite.newSpriteSheet(platform.spriteName, platform.spriteWidth, platform.spriteHeight)
platform.spriteSet = sprite.newSpriteSet(platform.spriteSheet, platform.spriteIdleFrameBegin, platform.spriteIdleFrameCount + platform.spriteFireFrameCount)

sprite.add(platform.spriteSet, 'idle', platform.spriteIdleFrameBegin, platform.spriteIdleFrameCount, platform.spriteIdleFrameRate, 0)
sprite.add(platform.spriteSet, 'fire', platform.spriteFireFrameBegin, platform.spriteFireFrameCount, platform.spriteFireFrameRate, 0)

function platform:new(center_x, center_y)
	if not platform.instance then
		platform.instance = {
			resources = 0,
			laser = nil,
			image = sprite.newSprite(platform.spriteSet),
			
			destroyed = false
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
	if not self.destroyed then
		self.image:removeSelf()
		Runtime:removeEventListener('accelerometer', onAccelerometer)
		Runtime:removeEventListener('touch', onTouch)
		platform.instance = nil
		
		self.destroyed = true
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
			if event.y > 400 then
				if platform.instance.charge == 0 then
					platform.instance.charge = 1
					platform.instance.image:prepare('fire')
					platform.instance.image:play()
				end
			end
		elseif event.phase == 'ended' or event.phase == 'cancelled' then
			platform.instance.image:setLinearVelocity(0, 0)
			platform.instance.charge = 0
			if platform.instance.laser ~= nil then
				platform.instance.laser:destroy()
				platform.instance.laser = nil
			end
			platform.instance.image:prepare('idle')
			platform.instance.image:play()
		end
	end
end

function platform:update(time)
	if self.charge == self.chargeFull then
		if not self.laser then
			self.laser = laser:new(self.image.x, self.image.y + laser.spriteHeight/2 + 44)
		end
	elseif self.charge > 0 then
		self.charge = self.charge + 1
	end
end

-- Laser/extraction-thingy class

laser = {
	-- Class constants
	--velocity = 400,
	
	spriteName = 'img/laser_stretch.png',
	spriteWidth = 26,
	spriteHeight = 540,
	spriteIdleFrameBegin = 1,
	spriteIdleFrameCount = 1,
	spriteIdleFrameRate = 1,
	
	list = {}
}
laser.spriteSheet = sprite.newSpriteSheet(laser.spriteName, laser.spriteWidth, laser.spriteHeight)
laser.spriteSet = sprite.newSpriteSet(laser.spriteSheet, laser.spriteIdleFrameBegin, laser.spriteIdleFrameCount)

sprite.add(laser.spriteSet, 'idle', laser.spriteIdleFrameBegin, laser.spriteIdleFrameCount, laser.spriteIdleFrameRate, 0)

function laser:new(center_x, center_y)
	local object = {
		image = sprite.newSprite(laser.spriteSet),
	
		destroyed = false
	}
	setmetatable(object, { __index = laser })
	
	--object.image:setFillColor(0,255,0)
		
	--physics.addBody(object.image, 'kinematic', {})
	
	--object.image.collision = laser.collide
	--object.image:addEventListener('collision', object.image)
	--object.image:setLinearVelocity(0, laser.velocity)
	
	--object.image.isFixedRotation = true
	--object.image.isBullet = true
	
	object.image.x = center_x
	object.image.y = center_y
	
	return object
end

function laser:update(time)
	-- Temporary non-physics based solution until collisions are worked out
	for _, i in ipairs(ground.list) do
		if self.image.x >= i:x() and self.image.x < i:x() + i.w then
			i:carve(self.image.x, 48, 1)
			break
		end
	end
end

function laser:destroy()
	if not destroyed then
		self.image:removeSelf()
		
		self.destroyed = true
	end
end

function laser:collide(event)
	--[[
	print('collision: phase = ' .. event.phase)
	print('other = ' .. event.other.x .. ' ' .. event.other.y)
	if event.other.__index == ground then
		print('kill')
		self.destroy()
	end
	--]]
end