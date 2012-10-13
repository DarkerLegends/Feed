/*

Name: 1337
Text: "1337 $ki11"
How: Get exactly 1337 kills.

Name: 123
Text: "1. 2. 3. Now I know my ABC's!"
How: Get exactly 123 kills.

Name: Hell's Janitor
Text: "What a mess.."
How: Get exactly 666 kills.

*/

mob/player/client/proc
	Kill_Check() //Checks the total kills for some kill-specific achievements.
		return
	/*	if(src.kills == 1337)
			if(!world.GetMedal("1337", src))
				world_chat("[src.key] unlocked the '1337' medal!")
				src << SOUND_ACHIEVEMENT_U
				world.SetMedal("1337", src)
		if(src.kills == 666)
			if(!world.GetMedal("Hell's Janitor", src))
				world_chat("[src.key] unlocked the 'Hell's Janitor' medal!")
				src << SOUND_ACHIEVEMENT_U
				world.SetMedal("Hell's Janitor", src)
		if(src.kills == 1)
			if(!world.GetMedal("First Blood", src))
				world_chat("[src.key] unlocked the 'First Blood' medal!")
				src << SOUND_ACHIEVEMENT_U
				world.SetMedal("First Blood", src) */
mob/proc
	medal_check(var/text/T)
		//if("Oops!")
		if(!world.GetMedal("Oops!", src))
			world_chat("[src.key] unlocked the 'Oops!' medal!")
			src << SOUND_ACHIEVEMENT_U
			world.SetMedal("Oops!", src)