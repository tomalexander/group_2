
sound = {
	laser = 'laser.mp3', -- extended sound as string
	laser_charge = media.newEventSound('laser_charge.mp3'),
	shield_spawn = media.newEventSound('shield_spawn.wav'),
	meteor_ground0 = media.newEventSound('meteor_ground0.wav'),
	meteor_ground1 = media.newEventSound('meteor_ground1.wav'),
	meteor_extractor = media.newEventSound('meteor_extractor.wav'),
	meteor_shield0 = media.newEventSound('meteor_shield0.wav'),
	meteor_shield1 = media.newEventSound('meteor_shield1.wav'),
	meteor_shield2 = media.newEventSound('meteor_shield2.wav'),
	meteor_shield3 = media.newEventSound('meteor_shield3.wav'),
	survivor_run = media.newEventSound('survivor_run.wav'),
	survivor_escape = media.newEventSound('survivor_escape.mp3'),
}

media.playSound(sound.laser)
media.stopSound()


