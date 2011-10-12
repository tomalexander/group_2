
sound = {
	laser = 'snd/laser.mp3', -- extended sound as string
	laser_charge = media.newEventSound('snd/laser_charge.mp3'),
	shield_spawn = media.newEventSound('snd/shield_spawn.wav'),
	--laser = audio.loadSound('snd/laser.mp3'),
	--laser_charge = audio.loadSound('snd/laser_charge.mp3'),
	--shield_spawn = audio.loadSound('snd/shield_spawn.wav'),
}

media.playSound(sound.laser)
media.stopSound()


