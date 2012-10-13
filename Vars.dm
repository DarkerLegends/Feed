var
	list
		muted = list()
		players = list()
obj/name_overlay
	layer = EFFECTS_LAYER


atom
	movable
		mouse_opacity = 0
		var/tmp
			is_garbage = 0
		proc
			GC()
	var/tmp
		is_dead = 0
		is_hit = 0
		escape_hit = 0
		health = 0
		maxhealth = 0
		rtype = 0
		is_good_bad = 0
		on_fire = 0
		fire_resistance = 0
	proc
		Death()

		addname() //var/text, var/py = 0)
			var/N = src.name
			if(length(N) > 16)
				N = copytext(N,1,16)
			var/obj/name_overlay/O = new
			O.maptext_width = 64
			O.maptext_height = 16
			O.maptext = "<center>[N]"
			O.pixel_x = -24
			O.pixel_y = -16
			src.overlays += O


		fire_damage(var/damage = 10, var/delay = 12, var/mob/player/client/P, skipo = 0)
			if(!src.is_dead)
				if(!src.on_fire)
					src.on_fire = 1
					if(!skipo) src.overlays.Add(FIRE_OVERLAY)
					spawn()
						while(src.on_fire)
							if(src.is_dead||gameover) break
							var/dmg = round(rand((damage / 2) , damage))
							switch(src.rtype)
								if(1, 2, 3)
									var/mob/Z = src
									if(Z.fire_resistance) dmg += Z.fire_resistance
									if(dmg < 1) dmg = 1
									Z.health -= dmg
									if(Z.health <= 0)
										if(src.rtype == 3 && P && !P.is_dead)
											P.kills ++
											P.exp ++
											spawn() P.Kill_Check()
											P.rank_up()
										Z.Death()
								if(43)
									var/obj/O = src
									O.health -= dmg
									if(O.health <= 0) O.Death()
							delay --
							if(delay <= 0) break
							sleep(10)
						if(!skipo) src.overlays.Remove(FIRE_OVERLAY)
						src.on_fire = 0

mob
	health = 100
	maxhealth = 100
	var/tmp
		unmovable = 0
		frozen = 0
		safe_delay = 0
	proc
		health_regen()
			while(src)
				if(src.is_dead == FALSE)
					if(src.health < src.maxhealth)
						src.health += 2
						if(src.health > src.maxhealth)
							src.health = src.maxhealth
				sleep(10)

	player
		is_good_bad = 1
		rtype = 1
		var/tmp
			gamein = 0
			items/weapons/weapon = null
			wait_delay = 0
			secondary_selected = null
			list/secondary_items = new/list()
		client
			rtype = 2
			see_in_dark = 5
			var/tmp
				wait_message = 0
				kills = 0
				has_revive = 0
				survived_wave = 0
				new_player = 1
				spec_number = 1
			Death(var/skip_d_msg = 0, var/s = null, var/dt = 0)
				if(!src.is_dead)
					if(src.has_revive)
						src.hide_unhide_huds(1)
						src.client.screen += new /ScreenFX/Respawn
						src.frozen = TRUE
						src.client.eye = src.loc
						src.loc = null
						sleep(40)
						for(var/ScreenFX/Respawn/R in src.client.screen)
							if(R) del R
						world_chat("\[&color=[src.color]][src.name]\[&color=null] was revived.")
						src.client.eye = src
						src.health = src.maxhealth
						src.has_revive = 0
						src.hide_unhide_huds(0)
						src.loc = pick(pspawn_zone)
						src.frozen = FALSE
						src.overlays.Remove(FIRE_OVERLAY)
						src.on_fire = 0
					else
						src.is_dead = 1
						src.gamein = 0
						src.health = 0
						src.density = 0
						src.unmovable = 0
						src.frozen = 0
						src.is_hit = 0
						src.escape_hit = 0
						src.invisibility = 6
						src.survived_wave = wave
						if(!skip_d_msg) world_chat("§ \[&color=[src.color]][src.name]\[&color=null] died! ([src.kills] kill\s)")
						if((src in ptracker)) {ptracker.Remove(src);check_round()}
						src.hide_unhide_huds(1)
						if(length(ptracker))
							for(var/mob/player/client/M in world)
								if(!M||!M.client||!M.is_dead||M.client.eye != src) continue
								if(M != src)
									var/mob/player/client/E = pick(ptracker)
									if(E) M.client.eye = E; src.client.chat.addText("Spectating: [E]", ChatFont, true)
							var/mob/player/client/N = pick(ptracker)
							if(N) src.client.chat.addText("Spectating: [N]", ChatFont, true)
							src.client.screen += spectate_stuff
						src.loc = locate(1,1,1)
						src << sound(null, channel = 50)


			proc
				game_message(var/txt)
					if(!src.wait_message)
						src.wait_message++
						spawn(25) src.wait_message = 0
						src << txt
				restore_vars()
					src.is_dead = 0
					src.gamein = 0
					src.health = src.maxhealth
					src.density = 0
					src.kills = 0
					src.unmovable = 0
					src.frozen = 0
					src.is_hit = 0
					src.escape_hit = 0
					src.client.eye = src
					src.loc = locate(1,1,1)
					src.has_revive = 0
					src.client.screen -= spectate_stuff
				respawn()
					if(!gameover)
						if(!src.gamein)
							if(gameon && gameon < 3)
								if(!src.is_dead)
									if(!(src.ID in played))
										played.Add(src.ID)
										if(!src.weapon) src.icon_state = "base-"
										else {src.icon_state = "[src.weapon.i_state]";src.weapon.clip = src.weapon.maxclip}
										src.health = src.maxhealth
										src.density = 1
										src.gamein = 1
										src.invisibility = 0
										if(!(src in ptracker)) ptracker.Add(src)
										if(!src.weapon)
											var/items/weapons/pistol/G = new/items/weapons/pistol
											G.Get(src)
										src.loc = pick(pspawn_zone)
										src.hide_unhide_huds()
										src.client.eye = src
										src << SOUND_WIND
										src.safe_delay = 1
										spawn(60)
											src.safe_delay = 0
						//				src << pick(MUSIC)
									else
										if(length(ptracker))
											var/mob/player/client/M = pick(ptracker)
											if(M) src.client.eye = M
											src.client.screen += spectate_stuff
											src.is_dead = 1
	Move()
		if(src.is_dead||src.unmovable||src.frozen||src.escape_hit)
			return 0
		..()

