
sound = {
	laser = 'laser.mp3', -- extended sound as string
	laser_charge = media.newEventSound('laser_charge.mp3'),
	shield_spawn = media.newEventSound('shield_spawn.wav'),
	--laser = audio.loadSound('laser.mp3'),
	--laser_charge = audio.loadSound('laser_charge.mp3'),
	--shield_spawn = audio.loadSound('shield_spawn.wav'),
}

media.playSound(sound.laser)
media.stopSound()


