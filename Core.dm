var
	gameon = 0
	gameover = 0
	round = 1
	challenge_wave = 0
	list/played = new/list()
	list/espawn_zone = new/list()
	list/erise_zone = new/list()
	list/pspawn_zone = new/list()
	list/ptracker = new/list()
	wave = 1
	zombie_t_spawn = 25
	zombie_t_kill = 25
	auto_target = 0
	boss = null

var/const/RESPAWN_TIME = 400
var/const/HITDELAY = 10
var/MOVEDELAY = 1

proc
	clean_up()
		current_map = "Unknown"
		played = new/list()
		ptracker = new/list()
		espawn_zone = new/list()
		erise_zone = new/list()
		pspawn_zone = new/list()
		for(var/area/A in world)
			if(!A) continue
			del(A)
		for(var/turf/T in world)
			if(!T) continue
			for(var/atom/movable/A in T)
				if(!A) continue
				if(A.is_garbage)
					A.GC()
				else
					switch(A.rtype)
						if(2)
							var/mob/player/client/M = A
							if(M.gamein) M.Death(1)
							M.restore_vars()
			if(T.z > 1) new/turf(T)
		world.maxx = 30
		world.maxy = 30
		world.maxz = 1
		gameover = 0
		gameon = 0
		wave = 1
		zombie_t_spawn = 25
		zombie_t_kill = 25
		auto_target = 0
		update_status()
		players << MUSIC_WAIT
		spawn() create_vetos()

	check_round()
		if(!gameover)
			if(length(ptracker) < 1)
				gameover = 1
				gameon = 3
				round ++
				world_alert("All players are dead.")
				players << SOUND_ALL_PLAYERS_DEAD
				sleep(20)
				world_chat("\[&color=#FF0000]Sending scores to hub..")
				for(var/mob/player/client/M in world)
					if(!M)continue
					M.set_scores()
				spawn() clean_up()


	wave_check()
		if(!gameover)
			if(zombie_t_kill < 1)
				for(var/mob/player/client/P in world)
					if(P.client && P)
						P.client.screen += wave_complete
						spawn(15)
						P.client.screen -= wave_complete


				players << SOUND_WAVE_COMPLETE
				wave ++
				zombie_t_spawn = 20*wave+rand(10,15)


				if(zombie_t_spawn > 800)
					zombie_t_spawn = 800
				zombie_t_kill = zombie_t_spawn


				for(var/mob/player/client/C in world)
					if(!C) continue
					if(C.is_dead)
						C.client.screen -= spectate_stuff
						C.is_dead = 0
						C.gamein = 1
						C.health = C.maxhealth
						C.density = 1
						C.unmovable = 0
						C.frozen = 0
						C.is_hit = 0
						C.escape_hit = 0
						C.invisibility = 0
						if(C.weapon) C.weapon.clip = C.weapon.maxclip
						else
							var/items/weapons/pistol/G = new/items/weapons/pistol
							G.Get(src)
						if(!(C in ptracker)) ptracker.Add(C)
						C.hide_unhide_huds(0)
						C.client.eye = C
						C.loc = pick(pspawn_zone)
				if(wave == 8)
					world_chat("Teleporters are functioning.")
					for(var/Tiles/Machines/Teleporter1/T1 in world)
						if(T1)
							T1.can_use = 1
							T1.icon_state = "on"
							world<<"Teleporter 1 - ON"
					for(var/Tiles/Machines/Teleporter2/T2 in world)
						if(T2)
							T2.can_use = 1
							T2.icon_state = "on"
							world<<"Teleporter 2 - ON"
				if(wave == 10 || wave == 20 || wave == 30 || wave == 40 || wave == 50)
					world_chat("The Skulker is coming..")
					boss = "skulker"
					zombie_t_kill = 1
					zombie_t_spawn = 1
				if(wave > 5 && prob(5+wave) && !boss)
					world_chat("A large horde is approaching..")
					boss = "outbreak"
					zombie_t_kill = rand(700,1100)
					zombie_t_spawn = zombie_t_kill
				update_status()
				world_chat("\[&color=#FF0000]Wave [wave] will begin in 10 seconds.")
				var/rc = "[round]"
				spawn(200)
					if(rc == "[round]")
						if(!gameover)
							world_chat("\[&color=#C0C0C0]Wave [wave] beginning.")
							players << SOUND_WAVE_BEGINING
							spawn() spawner(espawn_zone, erise_zone)

	spawner(var/list/L, var/list/R)
		if(length(L))
			if(boss == "skulker")
				//world << SOUND_SKULKER
				var/mob/enemys/S = garbage.Grab(/mob/enemys/skulker)
				if(S)
					S.is_dead = 0
					S.target = null
					S.health = S.maxhealth
					S.loc = pick(R)
					sleep(20)
				S.AI()
				boss = null
				return
			if(boss == "outbreak")
				for(var/mob/player/client/P in world)
					if(P.gamein)
						P.client.screen += outbreak
						spawn(30)
							P.client.screen -= outbreak
				world_chat("Outbreak!")
				boss = null

			for(var/i = 1, i <= zombie_t_spawn, i++)
				var/mob/enemys/Z
				if(prob(6)) Z = garbage.Grab(pick(/mob/enemys/brute, /mob/enemys/puker))
				else if(prob(0.09) && wave > 10)
					Z = garbage.Grab(/mob/enemys/blaze)
					world<<sound('blaze.ogg', 0)
				else if(prob(0.2) && wave > 10)
					Z = garbage.Grab(/mob/enemys/spectre)
					world<<sound('spectre.ogg', 0)
				else if(prob(10))
					Z = garbage.Grab(/mob/enemys/crawler)
				else	if(prob(5))
					Z = garbage.Grab(/mob/enemys/ninja)

				else Z = garbage.Grab(/mob/enemys/zombie)
				if(Z)
					Z.is_dead = 0
					Z.target = null
					Z.health = Z.maxhealth
					Z.health += wave+rand(10,30)
					if(wave >= 10)
						Z.speed = 2
					if(Z.type == /mob/enemys/zombie)
						if(prob(25))
							Z.loc = pick(R)
							flick("[Z.icon_state]-rise", Z)
							spawn(20) Z.AI()
						else
							Z.loc = pick(L)
							spawn(rand(5,10)) Z.AI()
					else
						Z.loc = pick(L)
						spawn(rand(5,10)) Z.AI()
				sleep(rand(0,5))