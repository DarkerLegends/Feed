mob/var/fire_proof = FALSE
obj
	shadow
		crawler
			icon = 'icons/_Crawler.dmi'
			icon_state = "shadow"
			layer = TURF_LAYER+0.3
		zombie
			icon = 'icons/_Zombie.dmi'
			icon_state = "shadow"
			layer = TURF_LAYER+0.3
		player
			icon = 'icons/_Clothes.dmi'
			icon_state = "shadow"
			layer = TURF_LAYER+0.3

	enemyW
		star
			icon = 'icons/_Bullets.dmi'
			icon_state = "star-red"
			density = 1
			var/tmp
				damage = 40
				termin = FALSE

			proc/damage(var/atom/movable/A)
				if((A != null))
					termin = TRUE
					switch(A.rtype)

						if(1, 2)
							var/mob/player/client/C = A
							C.client.screen += new /ScreenFX/Hurt
							spawn(1)
								C.remove_hurt()
							A.health -= src.damage

							if(prob(50))
								var/obj/effects/blood/O = garbage.Grab(/obj/effects/blood)
								if(O){O.icon_state = "blood[rand(1,7)]";O.loc = A.loc;O.DE_EO()}

							if(A.health <= 0)
								A.Death()
					src.GC()
			GC()
				src.loc = null
				garbage.Add(src)
			Bump()
				..()
				walk(src, 0)
				damage(src)

var/const/CHANCE_DROP = 40

var/list/drop_powerups = newlist(/items/other_items/revive, \
							/items/other_items/health_pack, \
							/items/secondary_items/molotov,\
							/items/secondary_items/grenade,\
							/items/secondary_items/mine,\
							/items/weapons/shotgun,\
							/items/weapons/pistol,\
							/items/weapons/crossbow,\
							/items/weapons/rifle,\
							/items/weapons/magnum, \
							/items/weapons/burst_rifle, \
							/items/weapons/flamethrower, \
							/items/weapons/grenade_launcher, \
							/items/weapons/auto_shotgun)


mob/enemys
	rtype = 3
	var/tmp
		lcheck = 0
		can_check = 1
		atk = 10
		speed = 3
		mob/player/target = null
		score = 1
	proc
		AI()
		Get_Target()
			if(length(ptracker))
				for(var/mob/player/M in ptracker)
					if(!M||!M.gamein||M.z != src.z||!M.safe_delay) continue
					if(!src.target||get_dist(src, M) < get_dist(src, src.target)||get_dist(src, M) == get_dist(src, src.target) && prob(50))
						src.target = M
	Bump(var/atom/A)
		..()
		if((A != null))
			switch(A.rtype)
				if(1, 2)

					if(!A.is_hit)
						A.is_hit = 1
						A.escape_hit = 1
						spawn(HITDELAY) if(A) A.is_hit = 0
						spawn((HITDELAY/2)) if(A) A.escape_hit = 0
						flick("[src.icon_state]-attack", src)

						var/dmg = rand(src.atk+5,src.atk-5)
						D_damage(A, "[dmg]")

						var/mob/player/client/C = A
						C.client.screen += new /ScreenFX/Hurt
						spawn(1)
							C.remove_hurt()

						A.health -= dmg
						var/obj/effects/blood/O = garbage.Grab(/obj/effects/blood)

						if(O){O.icon_state = "blood[rand(1,5)]";O.loc = A.loc;O.DE_EO()}

						if(A.health < 1) A.Death()
				if(43)
					if(prob(10))
						step(A, src.dir)

				if(45)
					var/Tiles/Barricades/B = A
					if(B.big)

						if(prob(30))
							B.health -= src.atk/2
							if(B.health <= 0)
								B.Death()
					else
						if(prob(20))
							step(B, src.dir)
						else if(prob(20))
							if(A.rtype == 45)
								A.health -= src.atk/2
								if(A.health <= 0)
									A.Death()
				else if(prob(50)) step_rand(src)


	Death(var/s = null, var/sa = null, var/dt = 0)
		if(!src.is_dead)
			src.is_dead = 1

			var/obj/effects/corpse/O = garbage.Grab(/obj/effects/corpse)
			if(O)
				if(!dt){O.icon = 'icons/_Zombie_Corpse.dmi';O.icon_state = "[src.icon_state]-dead";O.layer = pick(TURF_LAYER+0.41, TURF_LAYER+0.42, TURF_LAYER+0.43, TURF_LAYER+0.44, TURF_LAYER+0.45)}
				else
					O.icon = 'icons/_Gore.dmi'
					O.icon_state = "splatter"

					var/obj/effects/body_part/B = garbage.Grab(/obj/effects/body_part)
					if(B)
						B.pixel_x = rand(-4, 4)
						B.pixel_y = rand(-4, 4)
						B.density = 1
						B.icon_state = "[src.icon_state]-torso[pick(list("A","B"))]"
						B.dir = pick(NORTH,EAST,WEST,SOUTH,NORTHEAST,SOUTHEAST,NORTHWEST,SOUTHWEST)
						B.loc = src.loc
						spawn(rand(3,8))
							walk(B,0)
							B.density = 0
						walk(B,pick(NORTH,EAST,SOUTH,WEST,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST),1,1)
						B.DE_EO()

					var/obj/effects/body_part/H = garbage.Grab(/obj/effects/body_part)
					if(H)
						H.pixel_x = rand(-4, 4)
						H.pixel_y = rand(-4, 4)
						H.density = 1
						H.icon_state = "[src.icon_state]-head[pick(list("A","B"))]"
						H.dir = pick(NORTH,EAST,WEST,SOUTH,NORTHEAST,SOUTHEAST,NORTHWEST,SOUTHWEST)
						H.loc = src.loc
						spawn(rand(3,8))
							walk(H,0)
							H.density = 0
						walk(H,pick(NORTH,EAST,SOUTH,WEST,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST),1,1)
						H.DE_EO()
				O.loc = src.loc
				O.DE_EO()
			if(prob(CHANCE_DROP))
				if(!(locate(/items/) in src.loc))
					var/items/I = pick(drop_powerups)
					if(prob(I.chance)) new I.type(src.loc)
			src.loc = null
			src.GC()
			zombie_t_kill--
			wave_check()
	zombie
		name = "Average Joe"
		is_garbage = 1
		health = 80
		maxhealth = 80
		GC()
			src.loc = null
			src.is_dead = 1
			src.target = null
			src.can_check = 1
			garbage.Add(src)
		New()
			..()
			src.icon = 'icons/_Zombie.dmi'
			src.icon_state = pick(list("grey","green","purple","white"))
			src.underlays += new /obj/shadow/zombie
			if(src.icon_state == "purple")
				src.health = 110
				src.maxhealth = 110
	crawler
		name = "WTF is THAT"
		is_garbage = 1
		health = 50
		maxhealth = 50
		atk = 7
		speed = 2
		GC()
			src.loc = null
			src.is_dead = 1
			src.target = null
			src.can_check = 1
			garbage.Add(src)
		New()
			..()
			src.icon = 'icons/_Crawler.dmi'
			src.icon_state = pick(list("white","grey"))
			src.underlays += new /obj/shadow/crawler
	brute
		name = "bruutee"
		is_garbage = 1
		atk = 70
		health = 400
		maxhealth = 400
		score = 5
		speed = 4
		icon = 'icons/_Brute.dmi'
		icon_state = "brute"
		GC()
			src.loc = null
			src.is_dead = 1
			src.target = null
			src.can_check = 1
			garbage.Add(src)
	ninja
		name = "Asian zombie? Olololol"
		is_garbage = 1 //Get it.. Cause it's asian.. *ba dum tss*
		atk = 30
		health = 90
		maxhealth = 90
		score = 5
		speed = 2
		icon = 'icons/_Ninja.dmi'
		icon_state = "ninja"
		GC()
			src.loc = null
			src.is_dead = 1
			src.target = null
			src.can_check = 1
			garbage.Add(src)
		AI()
			if(!gameover)
				if(!src.is_dead)
					var/time = MOVEDELAY
					if(src.can_check)
						src.can_check = 0
						for(var/mob/player/M in ptracker)
							if(src.z == M.z)
								if(!M||!M.gamein) continue
								var/distc = get_dist(src, M)
								if(distc > 8) continue
								if(prob(30)) M << pick(s_growl)
								if(!src.target||distc < get_dist(src, src.target))
									src.target = M
									break
					else
						if(src.lcheck > 2) {src.lcheck = 0;src.can_check = 1}
						else src.lcheck++
					if(!src.target||!src.target.gamein||src.target.z != src.z)
						if(auto_target)
							src.Get_Target()
							time += rand(5,10)
						else
							time += rand(3,6)
							step_rand(src)
					else
						time += rand(2, 4)
						var/disch = get_dist(src, src.target)
						if(disch <= 6 && src.z == src.target.z)
							var/turf/T = get_step(src, get_dir(src, src.target))
							if(T)
								if(!T.density)
									var/obj/enemyW/star/S = garbage.Grab(/obj/enemyW/star)
									if(S)
										flick("[src.icon_state]-attack", src)
										S.termin = FALSE
										S.loc = src.loc
										walk(S,src.dir)
										spawn(50)
											if(!S.termin)
												walk(S, 0)
												S.GC()
						var/ldir = get_dir(src, src.target)
						var/turf/T = get_step(src, ldir)
						if(isturf(T))
							if(prob(25))
								var/atom/C = null
								switch(rand(1,2))
									if(1) C = get_step(src, turn(ldir, 45))
									if(2) C = get_step(src, turn(ldir, -45))
								if(isturf(C)) T = C
							step_towards(src, T)
						else step_towards(src, src.target)
					spawn(time+5) src.AI()
	blaze
		name = "Fuuuckkk"
		atk = 20
		health = 1000
		maxhealth = 1000
		score = 50
		icon = 'icons/_Blaze.dmi'
		icon_state = "blaze"
		fire_proof = TRUE
		var/tmp
			special_attack = 0
			run_away = 0
		GC()
			src.loc = null
			src.is_dead = 1
			src.target = null
			src.can_check = 1
			src.run_away = 0
			src.special_attack = 0
			src.density = 1
			src.icon_state = "blaze"
			garbage.Add(src)
		Bump(var/atom/A)
			..()
			if((A != null))
				switch(A.rtype)
					if(1, 2)
						if(!A.is_hit)
							A.is_hit = 1
							A.escape_hit = 1
							spawn(HITDELAY) if(A) A.is_hit = 0
							spawn((HITDELAY/2)) if(A) A.escape_hit = 0
							flick("[src.icon_state]-attack", src)
							if(prob(40))
								A.fire_damage(5, 3)
							else
								var/dmg = rand(src.atk+5,src.atk-5)
								var/mob/player/client/C = A
								C.client.screen += new /ScreenFX/Hurt
								spawn(1)
									C.remove_hurt()
								A.health -= dmg
								var/obj/effects/blood/O = garbage.Grab(/obj/effects/blood)
								if(O){O.icon_state = "blood[rand(1,5)]";O.loc = A.loc;O.DE_EO()}
								if(A.health < 1) A.Death()

					if(43, 45)
						if(prob(10))
							step(A, src.dir)
					else if(prob(50)) step_rand(src)
		AI()
			if(!gameover)
				if(!src.is_dead)
					step_rand(src)
					var/obj/triggys/hazards/fire/O = garbage.Grab(/obj/triggys/hazards/fire)
					if(O)
						O.pixel_x = rand(-4, 4)
						O.pixel_y = rand(-4, 4)
						O.icon_state = "fire[rand(1,2)]"
						O.loc = src.loc
						spawn(rand(30, 50)) O.GC()
					sleep(rand(1,3))
					src.AI()





	//Skulker and Spyder time! :D


	skulker
		name = "Nigger, Chink, Spic"
		is_garbage = 1
		atk = 25
		health = 20000
		maxhealth = 20000
		fire_proof = 1
		score = 500
		icon = 'icons/_Skulker.dmi'
		icon_state = "skulker"
		pixel_x = -14
		var/tmp
			run_away = 0
			run_to = 0
			hide = 0
		GC()
			src.loc = null
			src.is_dead = 1
			src.target = null
			src.can_check = 1
			src.run_away = 0
			src.hide = 0
			src.run_to = 0
			src.density = 1
			src.icon_state = "skulker"
			garbage.Add(src)
		Bump(var/atom/A)
			..()
			if((A != null))
				switch(A.rtype)
					if(1, 2)
						if(!A.is_hit)
							A.is_hit = 1
							A.escape_hit = 1
							spawn(HITDELAY) if(A) A.is_hit = 0
							spawn((HITDELAY/2)) if(A) A.escape_hit = 0
							flick("[src.icon_state]-attack", src)
							if(prob(40))
								A.fire_damage(5, 3)
							else
								var/dmg = rand(src.atk+5,src.atk-5)
								var/mob/player/client/C = A
								C.client.screen += new /ScreenFX/Hurt
								spawn(1)
									C.remove_hurt()
								A.health -= dmg
								var/obj/effects/blood/O = garbage.Grab(/obj/effects/blood)
								if(O){O.icon_state = "blood[rand(1,5)]";O.loc = A.loc;O.DE_EO()}
								if(A.health < 1) A.Death()
		AI()
			if(!gameover)
				if(!src.is_dead)
					if(hide)  //If it's hiding, waiting to be hit..
						for(var/mob/player/client/C in oview(2,src))
							if(C && C.gamein)
								src.run_to = 1
								src.hide = 0
								src.target = C
								for(var/mob/enemys/spyder/S in world)
									if(S) // <-- lolwut?
										S.icon_state = "spyder-vanish"
										spawn(4)
											S.GC()
					if(run_to)
						if(src.target)
							step_towards(src, src.target)
							if(get_dist(src, src.target) == 1 && src.z == src.target.z)
								src.frozen = 1
								sleep(3)
								flick("skulker-attack", src)
								src.frozen = 0
								src.target.client.screen += new /ScreenFX/Hurt
								spawn(1)
									var/mob/player/client/P = src.target
									P.remove_hurt()
								src.target.health -= rand(15,30)
								if(src.target.health < 1)
									src.target.Death()

								src.run_away = 1
								src.run_to = 0
							if(prob(2))
								src.run_to = 0
								src.run_away = 1
						else
							for(var/mob/player/client/P in world)
								if(P && P.gamein && P.z == src.z)
									src.target = P
					if(run_away)
						step_rand(src)
						var/obj/triggys/hazards/fire/O = garbage.Grab(/obj/triggys/hazards/fire)
						if(O)
							O.pixel_x = rand(-4, 4)
							O.pixel_y = rand(-4, 4)
							O.icon_state = "fire[rand(1,2)]"
							O.loc = src.loc
							spawn(rand(30, 50)) O.GC()
						if(prob(5))
							run_away = 0

					if(hide == run_to == run_away == 0) //If none of the above are true
						if(prob(60))
							run_to = 1
							for(var/mob/player/client/O in world)
								if(O)
									src.target = O
						else
							hide = 1
							var/spyders = rand(40,90)
							for(spyders, spyders > 0, spyders--)
								var/mob/enemys/spyder/S = garbage.Grab(/mob/enemys/spyder)
								if(S)
									S.is_dead = 0
									S.target = null
									S.health = S.maxhealth
									S.loc = pick(erise_zone)
									flick("spyder-rise", S)
									spawn() S.AI()
									sleep(rand(1,2))





					sleep(1.5)
					src.AI()




		Death(var/s = null, var/sa = null, var/dt = 0)
			if(!src.is_dead)
				src.is_dead = 1

				var/obj/effects/corpse/O = garbage.Grab(/obj/effects/corpse)
				if(O)
					if(!dt){O.icon = 'icons/_Zombie_Corpse.dmi';O.icon_state = "[src.icon_state]-dead";O.layer = pick(TURF_LAYER+0.41, TURF_LAYER+0.42, TURF_LAYER+0.43, TURF_LAYER+0.44, TURF_LAYER+0.45)}
					else
						O.icon = 'icons/_Gore.dmi'
						O.icon_state = "splatter"

						var/obj/effects/body_part/B = garbage.Grab(/obj/effects/body_part)
						if(B)
							B.pixel_x = rand(-4, 4)
							B.pixel_y = rand(-4, 4)
							B.density = 1
							B.icon_state = "[src.icon_state]-torso[pick(list("A","B"))]"
							B.dir = pick(NORTH,EAST,WEST,SOUTH,NORTHEAST,SOUTHEAST,NORTHWEST,SOUTHWEST)
							B.loc = src.loc
							spawn(rand(3,8))
								walk(B,0)
								B.density = 0
							walk(B,pick(NORTH,EAST,SOUTH,WEST,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST),1,1)
							B.DE_EO()
						var/obj/effects/body_part/H = garbage.Grab(/obj/effects/body_part)
						if(H)
							H.pixel_x = rand(-4, 4)
							H.pixel_y = rand(-4, 4)
							H.density = 1
							H.icon_state = "[src.icon_state]-head[pick(list("A","B"))]"
							H.dir = pick(NORTH,EAST,WEST,SOUTH,NORTHEAST,SOUTHEAST,NORTHWEST,SOUTHWEST)
							H.loc = src.loc
							spawn(rand(3,8))
								walk(H,0)
								H.density = 0
							walk(H,pick(NORTH,EAST,SOUTH,WEST,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST),1,1)
						H.DE_EO()
					O.loc = src.loc
					O.DE_EO()
				for(var/mob/enemys/spyder/S in world)
					if(S)
						S.icon_state = "spyder-vanish"
						spawn(4)
							S.GC()
				if(prob(CHANCE_DROP))
					if(!(locate(/items/) in src.loc))
						var/items/I = pick(drop_powerups)
						if(prob(I.chance)) new I.type(src.loc)
				src.loc = null
				src.GC()
				zombie_t_kill--
				wave_check()



	spyder
		name = "Yo, they explode, niqqa"
		is_garbage = 1
		atk = 5
		health = 50
		maxhealth = 50
		score = 3
		icon = 'icons/_Spyder.dmi'
		icon_state = "spyder"
		GC()
			src.loc = null
			src.is_dead = 1
			src.target = null
			src.can_check = 1
			src.density = 1
			src.icon_state = "spyder"
			garbage.Add(src)
		AI()
			if(!gameover)
				if(!src.is_dead)
					for(var/mob/player/client/C in world)
						if(C.gamein)
							if(get_dist(src, C) <= 2)
								src.Death()
					sleep(5)
					src.AI()
		Death()
			if(!src.is_dead)
				src.is_dead = 1
				src.icon_state = "spyder-attack"
				sleep(9)
				for(var/mob/player/client/P in oview(2,src))
					if(P && P.gamein)
						P.health -= 600
						P.Death()
				src.Explode(2, 600)





	spectre
		name = "OFUCK, NIGGA"
		is_garbage = 1
		atk = 5
		health = 500
		maxhealth = 500
		score = 50
		icon = 'icons/_Spectre.dmi'
		icon_state = "spectre"
		var/tmp
			special_attack = 0
			run_away = 0
		GC()
			src.loc = null
			src.is_dead = 1
			src.target = null
			src.can_check = 1
			src.run_away = 0
			src.special_attack = 0
			src.density = 1
			src.icon_state = "spectre"
			garbage.Add(src)
		Bump(var/atom/A)
			..()
			if((A != null))
				switch(A.rtype)
					if(1, 2)
						if(!A.is_hit)
							A.is_hit = 1
							A.escape_hit = 1
							spawn(HITDELAY) if(A) A.is_hit = 0
							spawn((HITDELAY/2)) if(A) A.escape_hit = 0
							flick("[src.icon_state]-attack", src)
							if(prob(40))
								A.fire_damage(5, 3)
							else
								var/dmg = rand(src.atk+5,src.atk-5)
								var/mob/player/client/C = A
								C.client.screen += new /ScreenFX/Hurt
								spawn(1)
									C.remove_hurt()
								A.health -= dmg
								var/obj/effects/blood/O = garbage.Grab(/obj/effects/blood)
								if(O){O.icon_state = "blood[rand(1,5)]";O.loc = A.loc;O.DE_EO()}
								if(A.health < 1) A.Death()

					if(43, 45)
						if(prob(10))
							step(A, src.dir)
					else if(prob(50)) step_rand(src)
		AI()
			if(!gameover)
				if(!src.is_dead)
					var/time = MOVEDELAY
					if(!src.target||!src.target.gamein)
						src.run_away = 0
						src.density = 1
						src.icon_state = "spectre"
						src.special_attack = 0
						src.Get_Target()
						time += rand(5,10)
					else
						time ++
						if(src.run_away)
							src.run_away--
							if(src.run_away <= 0)
								src.run_away = 0
								src.icon_state = "spectre-teleport"
								src.density = 0
								spawn(50) src.special_attack = 0
							else step_away(src, src.target, 30)
						else
							if(!src.special_attack)
								src.special_attack = 1

								var/list/L = list()
								for(var/mob/player/M in ptracker)
									if(!M||!M.gamein) continue
									L += M

								if(length(L))
									src.target = pick(L)
									src.loc = src.target.loc
									src.density = 1
									src.icon_state = "spectre"
									if(prob(40))
										src.Bump(src.target)
									src.run_away = rand(20, 30)
								else src.special_attack = 0

					spawn(time) src.AI()

	puker
		name = "That rich guy that was wasted at a champaign ball when the zombie apocalypse started."
		is_garbage = 1
		atk = 20 //Puker's attack variable isn't really relevant seeing how it doesn't directly attack the player.
		health = 80 //Weak, obviously.
		maxhealth = 80
		score = 1
		icon = 'icons/_Puker.dmi'
		icon_state = "blue"
		var
			special_attack = 0
		New()
			..()
			src.underlays += new/obj/shadow/zombie
		GC()
			src.loc = null
			src.is_dead = 1
			src.target = null
			src.can_check = 1
			src.special_attack = 0
			garbage.Add(src)
		AI()
			if(!gameover)
				if(!src.is_dead)
					var/time = MOVEDELAY
					if(src.can_check)
						src.can_check = 0
						for(var/mob/player/M in ptracker)
							if(M.z == src.z)
								if(!M||!M.gamein) continue
								var/distc = get_dist(src, M)
								if(distc > 8) continue
								if(prob(30)) M << pick(s_growl)
								if(!src.target||distc < get_dist(src, src.target))
									src.target = M
									break
					else
						if(src.lcheck > 2) {src.lcheck = 0;src.can_check = 1}
						else src.lcheck++
					if(!src.target||!src.target.gamein||src.target.z != src.z)
						if(auto_target)
							src.Get_Target()
							time += rand(5,10)
						else
							time += rand(3,6)
							step_rand(src)
					else
						time += rand(2, 4)
						var/disch = get_dist(src, src.target)
						if(disch <= 6)
							if(!src.special_attack)
								var/turf/T = get_step(src, get_dir(src, src.target))
								if(T)
									if(!T.density)
										var/obj/triggys/hazards/vomit/C = locate(/obj/triggys/hazards/vomit) in T
										if(!C)
											var/obj/triggys/hazards/vomit/V = garbage.Grab(/obj/triggys/hazards/vomit)
											if(V)
												src.special_attack = 1
												spawn(40) src.special_attack = 0
												flick("[src.icon_state]-attack", src)
												V.loc = T
												spawn(rand(200, 400)) V.GC()
						var/ldir = get_dir(src, src.target)
						var/turf/T = get_step(src, ldir)
						if(isturf(T))
							if(prob(25))
								var/atom/C = null
								switch(rand(1,2))
									if(1) C = get_step(src, turn(ldir, 45))
									if(2) C = get_step(src, turn(ldir, -45))
								if(isturf(C)) T = C
							step_towards(src, T)
						else step_towards(src, src.target)
					spawn(time) src.AI()
	AI()
		if(!gameover)
			if(!src.is_dead)
				if(src.can_check)
					src.can_check = 0
					for(var/mob/player/M in ptracker)
						if(M.z == src.z)
							if(!M||!M.gamein) continue
							var/distc = get_dist(src, M)
							if(distc > 8) continue
							if(prob(50)) M << pick(s_growl)
							if(!src.target||distc < get_dist(src, src.target))

								src.target = M
								break
				else
					if(src.lcheck > 2) {src.lcheck = 0;src.can_check = 1}
					else src.lcheck++
				if(!src.target||!src.target.gamein||src.target.z != src.z)
					if(auto_target)
						src.Get_Target()
					else
						step_rand(src)
				else
					var/disch = get_dist(src, src.target)
					if(disch <= 1 && src.z == src.target.z)
						src.Bump(src.target)
					else
						var/ldir = get_dir(src, src.target)
						var/turf/T = get_step(src, ldir)
						if(isturf(T))
							if(prob(25))
								var/atom/C = null
								switch(rand(1,2))
									if(1) C = get_step(src, turn(ldir, 45))
									if(2) C = get_step(src, turn(ldir, -45))
								if(isturf(C)) T = C
							step_towards(src, T)
						else step_towards(src, src.target)
				spawn(rand(src.speed, src.speed+2)) src.AI()