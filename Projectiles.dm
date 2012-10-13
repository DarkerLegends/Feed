atom/var/de_dignore = 0

obj/projectiles
	is_garbage = 1
	layer = TURF_LAYER+2
	icon = 'icons/_Bullets.dmi'
	var/tmp
		mob/player/client/owner = null
		speed = 1
		damage = 0
		max_dist = 100
		turf/wloc = null
	GC()
		src.max_dist = initial(src.max_dist)
		src.damage = 0
		src.loc = null
		src.owner = null
		garbage.Add(src)
	proc
		DE_D(var/atom/mobable/A)
		DE_T(var/turf/T)
			if(!T) return
			if(T.x <= 1||T.x >= world.maxx||T.y <= 1||T.y >= world.maxy||T.density && !T.de_dignore)
				return 1
		DE_A()
			src.GC()
		DE_L()
			var/count = src.max_dist
			var/cancel_tc = 0
			while((count > 0))
				if(gameover) {src.wloc = null;return}
				var/turf/T = src.loc
				if(src.DE_T(T)){cancel_tc++;break}
				for(var/atom/movable/A in T)
					if(!A||!A.density||A.is_good_bad||A.de_dignore) continue
					src.DE_D(A)
					cancel_tc++
					break
				if(cancel_tc) break
				count--
				if(src.wloc)
					if(src.loc != src.wloc)
						step(src, get_dir(src, src.wloc))
					else break
				else step(src, src.dir)
				sleep(((MOVEDELAY/2) + src.speed))
			src.wloc = null
			src.DE_A()
	shotgun_blast
		icon_state = "spread"
		speed = 0
		max_dist = 8
		DE_A()
			spawn() src.GC()
		DE_D(var/atom/movable/A)
			if((A != null))
				switch(A.rtype)
					if(3)

						A.health -= src.damage*(src.owner.rank/2)
						if(prob(60))
							var/obj/effects/blood/O = garbage.Grab(/obj/effects/blood)
							if(O){O.icon_state = "blood[rand(1,9)]";O.loc = A.loc;O.DE_EO()}
						if(A.health <= 0)
							if(src.owner)
								src.owner.kills += A:score
								src.owner.exp += A:score
								spawn() src.owner.Kill_Check()
							A.Death()
							src.owner.rank_up()
						if(A.type == /mob/enemys/skulker)
							var/mob/enemys/skulker/S = A
							if(S.hide)
								S.run_to = 1
								S.hide = 0
								S.target = src.owner
								for(var/mob/enemys/spyder/P in world)
									if(P)
										P.icon_state = "spyder-vanish"
										spawn(4)
											P.GC()
						return 1
					if(43)
						var/obj/enviroment/hazard/barrel/O = A
						if(!O.owner) if(src.owner) O.owner = src.owner
						A.Death()
						return 1
	pistol_bullet
		icon_state = "bullet"
		speed = 0
		max_dist = 40
		DE_A()
			spawn() src.GC()
		DE_D(var/atom/movable/A)
			if((A != null))
				switch(A.rtype)
					if(3)

						A.health -= src.damage*(src.owner.rank/2)
						var/obj/effects/impact/I = new
						A.overlays += I
						spawn(6)
							A.overlays -= I
						if(prob(60))
							var/obj/effects/blood/O = garbage.Grab(/obj/effects/blood)
							if(O){O.icon_state = "blood[rand(1,9)]";O.loc = A.loc;O.DE_EO()}

						if(A.health <= 0)
							if(src.owner)
								src.owner.kills += A:score
								src.owner.exp += A:score
								spawn() src.owner.Kill_Check()
							A.Death()
							src.owner.rank_up()
						if(A.type == /mob/enemys/skulker)
							var/mob/enemys/skulker/S = A
							if(S.hide)
								S.run_to = 1
								S.hide = 0
								S.target = src.owner
								for(var/mob/enemys/spyder/P in world)
									if(P)
										P.icon_state = "spyder-vanish"
										spawn(4)
											P.GC()
						return 1
					if(43)
						var/obj/enviroment/hazard/barrel/O = A
						if(!O.owner) if(src.owner) O.owner = src.owner
						A.Death()
						return 1
	magnum_bullet
		icon_state = "bullet"
		speed = 0
		max_dist = 12
		DE_A()
			spawn() src.GC()
		DE_D(var/atom/movable/A)
			if((A != null))
				switch(A.rtype)
					if(3)

						A.health -= src.damage*(src.owner.rank/2)
						var/obj/effects/impact/I = new
						A.overlays += I
						spawn(6)
							A.overlays -= I
						if(prob(60))
							var/obj/effects/blood/O = garbage.Grab(/obj/effects/blood)
							if(O){O.icon_state = "blood[rand(1,9)]";O.loc = A.loc;O.DE_EO()}
						if(A.health <= 0)
							if(src.owner)
								src.owner.kills += A:score
								src.owner.exp += A:score
								spawn() src.owner.Kill_Check()
							A.Death()
							src.owner.rank_up()
						if(A.type == /mob/enemys/skulker)
							var/mob/enemys/skulker/S = A
							if(S.hide)
								S.run_to = 1
								S.hide = 0
								S.target = src.owner
								for(var/mob/enemys/spyder/P in world)
									if(P)
										P.icon_state = "spyder-vanish"
										spawn(4)
											P.GC()
						return 1
					if(43)
						var/obj/enviroment/hazard/barrel/O = A
						if(!O.owner) if(src.owner) O.owner = src.owner
						A.Death()
						return 1
	rifle_bullet
		icon_state = "bullet"
		speed = 0
		max_dist = 40
		DE_A()
			spawn() src.GC()
		DE_D(var/atom/movable/A)
			if((A != null))
				switch(A.rtype)
					if(3)
						A.health -= src.damage*(src.owner.rank/2)
						var/obj/effects/impact/I = new
						A.overlays += I
						spawn(6)
							A.overlays -= I
						if(prob(60))
							var/obj/effects/blood/O = garbage.Grab(/obj/effects/blood)
							if(O){O.icon_state = "blood[rand(1,9)]";O.loc = A.loc;O.DE_EO()}
						if(A.health <= 0)
							if(src.owner)
								src.owner.kills += A:score
								src.owner.exp += A:score
								spawn() src.owner.Kill_Check()
							A.Death()
							src.owner.rank_up()
						if(A.type == /mob/enemys/skulker)
							var/mob/enemys/skulker/S = A
							if(S.hide)
								S.run_to = 1
								S.hide = 0
								S.target = src.owner
								for(var/mob/enemys/spyder/P in world)
									if(P)
										P.icon_state = "spyder-vanish"
										spawn(4)
											P.GC()
						return 1
					if(43)
						var/obj/enviroment/hazard/barrel/O = A
						if(!O.owner) if(src.owner) O.owner = src.owner
						A.Death()
						return 1
	burst_bullet
		icon_state = "bullet"
		speed = 0
		max_dist = 50
		DE_A()
			spawn() src.GC()
		DE_D(var/atom/movable/A)
			if((A != null))
				switch(A.rtype)
					if(3)
						A.health -= src.damage*(src.owner.rank/2)
						var/obj/effects/impact/I = new
						A.overlays += I
						spawn(6)
							A.overlays -= I
						if(prob(60))
							var/obj/effects/blood/O = garbage.Grab(/obj/effects/blood)
							if(O){O.icon_state = "blood[rand(1,9)]";O.loc = A.loc;O.DE_EO()}
						if(A.health <= 0)
							if(src.owner)
								src.owner.kills += A:score
								src.owner.exp += A:score
								spawn() src.owner.Kill_Check()
							A.Death()
							src.owner.rank_up()
						if(A.type == /mob/enemys/skulker)
							var/mob/enemys/skulker/S = A
							if(S.hide)
								S.run_to = 1
								S.hide = 0
								S.target = src.owner
								for(var/mob/enemys/spyder/P in world)
									if(P)
										P.icon_state = "spyder-vanish"
										spawn(4)
											P.GC()
						return 1
					if(43)
						var/obj/enviroment/hazard/barrel/O = A
						if(!O.owner) if(src.owner) O.owner = src.owner
						A.Death()
						return 1
	bolt
		icon_state = "bolt"
		speed = 0
		max_dist = 40
		DE_A()
			spawn() src.GC()
		DE_D(var/atom/movable/A)
			if((A != null))
				switch(A.rtype)
					if(3)
						A.health -= src.damage*(src.owner.rank/2)
						var/obj/effects/impact/I = new
						A.overlays += I
						spawn(6)
							A.overlays -= I
						if(prob(60))
							var/obj/effects/blood/O = garbage.Grab(/obj/effects/blood)
							if(O){O.icon_state = "blood[rand(1,9)]";O.loc = A.loc;O.DE_EO()}
						if(A.health <= 0)
							if(src.owner)
								src.owner.kills += A:score
								src.owner.exp += A:score
								spawn() src.owner.Kill_Check()
							A.Death()
							src.owner.rank_up()
						if(A.type == /mob/enemys/skulker)
							var/mob/enemys/skulker/S = A
							if(S.hide)
								S.run_to = 1
								S.hide = 0
								S.target = src.owner
								for(var/mob/enemys/spyder/P in world)
									if(P)
										P.icon_state = "spyder-vanish"
										spawn(4)
											P.GC()
						return 1
					if(43)
						var/obj/enviroment/hazard/barrel/O = A
						if(!O.owner) if(src.owner) O.owner = src.owner
						A.Death()
						return 1
	flamethrower_bullet
		icon_state = "fireblast"
		speed = 0.1
		max_dist = 8
		DE_A()
			spawn() src.GC()
		DE_D(var/atom/movable/A)
			if((A != null))
				switch(A.rtype)
					if(3)
						A.fire_damage(70, 3, src.owner)

						if(A.type == /mob/enemys/skulker)
							var/mob/enemys/skulker/S = A
							if(S.hide)
								S.run_to = 1
								S.hide = 0
								S.target = src.owner
								for(var/mob/enemys/spyder/P in world)
									if(P)
										P.icon_state = "spyder-vanish"
										spawn(4)
											P.GC()
						return 1
					if(43)
						var/obj/enviroment/hazard/barrel/O = A
						if(!O.owner) if(src.owner) O.owner = src.owner
						A.Death()
						return 1
		DE_L()
			var/count = src.max_dist
			var/cancel_tc = 0
			while((count > 0))
				if(gameover) {src.wloc = null;return}
				var/turf/T = src.loc
				if(src.DE_T(T)){cancel_tc++;break}
				for(var/atom/movable/A in T)
					if(!A||!A.density||A.is_good_bad||A.de_dignore) continue
					src.DE_D(A)
					cancel_tc++
					break
				if(cancel_tc) break
				count--
				if(src.wloc)
					if(src.loc != src.wloc)
						step(src, get_dir(src, src.wloc))
					else break
				else
					if(prob(40) && count <= src.max_dist-5)
						var/obj/triggys/hazards/fire/O = garbage.Grab(/obj/triggys/hazards/fire)
						if(O)
							O.pixel_x = rand(-4, 4)
							O.pixel_y = rand(-4, 4)
							O.icon_state = "fire[rand(1,2)]"
							O.loc = src.loc
							O.owner = src.owner
							spawn(rand(50, 100)) O.GC()
					step(src, src.dir)
				sleep(((MOVEDELAY/2) + src.speed))
			src.wloc = null
			src.DE_A()
		DE_A()
			var/list/F = new/list()
			for(var/turf/T in de_view(2, src))
				if(!T||T.density) continue
				for(var/atom/movable/A in T)
					if(!A||!A.density||A.is_dead) continue
					switch(A.rtype)
						if(1,2)
							var/mob/player/P = A
							if(P.gamein)
								P.fire_damage(20, 5, src.owner)
						if(3)
							var/mob/M = A
							M.fire_damage(40, 5, src.owner)
						if(43)
							var/obj/enviroment/hazard/barrel/O = A
							if(!O.owner) if(src.owner) O.owner = src.owner
							O.fire_damage(20, 5, src.owner, 1)
				F += T
			if(length(F))
				var/ftc = rand(3, 8)
				for(var/i = 1, i <= ftc, i++)
					if(!length(F)) break
					var/obj/triggys/hazards/fire/O = garbage.Grab(/obj/triggys/hazards/fire)
					if(O)
						O.pixel_x = rand(-4, 4)
						O.pixel_y = rand(-4, 4)
						O.icon_state = "fire[rand(1,2)]"
						var/turf/tp = pick(F)
						O.loc = tp
						O.owner = src.owner
						F -= tp
						spawn(rand(50, 100)) O.GC()
			src.GC()
	autoshotgun_blast
		icon_state = "spread"
		speed = 0
		max_dist = 5
		DE_A()
			spawn() src.GC()
		DE_D(var/atom/movable/A)
			if((A != null))
				switch(A.rtype)
					if(3)

						A.health -= src.damage*(src.owner.rank/2)
						if(prob(60))
							var/obj/effects/blood/O = garbage.Grab(/obj/effects/blood)
							if(O){O.icon_state = "blood[rand(1,9)]";O.loc = A.loc;O.DE_EO()}
						if(A.health <= 0)
							if(src.owner)
								src.owner.kills += A:score
								src.owner.exp += A:score
								spawn() src.owner.Kill_Check()
							A.Death()
							src.owner.rank_up()
						if(A.type == /mob/enemys/skulker)
							var/mob/enemys/skulker/S = A
							if(S.hide)
								S.run_to = 1
								S.hide = 0
								S.target = src.owner
								for(var/mob/enemys/spyder/P in world)
									if(P)
										P.icon_state = "spyder-vanish"
										spawn(4)
											P.GC()
						return 1
					if(43)
						var/obj/enviroment/hazard/barrel/O = A
						if(!O.owner) if(src.owner) O.owner = src.owner
						A.Death()
						return 1
	molotov
		icon_state = "molotov"
		speed = 0.5
		max_dist = 7
		DE_A()
			var/list/F = new/list()
			for(var/turf/T in de_view(2, src))
				if(!T||T.density) continue
				for(var/atom/movable/A in T)
					if(!A||!A.density||A.is_dead) continue
					switch(A.rtype)
						if(1,2)
							var/mob/player/P = A
							if(P.gamein)
								P.fire_damage(20, 5, src.owner)
						if(3)
							var/mob/M = A
							M.fire_damage(40, 5, src.owner)
						if(43)
							var/obj/enviroment/hazard/barrel/O = A
							if(!O.owner) if(src.owner) O.owner = src.owner
							O.fire_damage(20, 5, src.owner, 1)
				F += T
			if(length(F))
				var/ftc = rand(8, 16)
				for(var/i = 1, i <= ftc, i++)
					if(!length(F)) break
					var/obj/triggys/hazards/fire/O = garbage.Grab(/obj/triggys/hazards/fire)
					if(O)
						O.pixel_x = rand(-4, 4)
						O.pixel_y = rand(-4, 4)
						O.icon_state = "fire[rand(1,2)]"
						var/turf/tp = pick(F)
						O.loc = tp
						O.owner = src.owner
						F -= tp
						spawn(rand(200, 400)) O.GC()
			src.GC()
	grenade
		icon_state = "grenade"
		speed = 0.5
		max_dist = 7
		DE_A()
			src.Explode(3, 500, src.owner)
	launch_grenade
		icon_state = "launchgrenade"
		speed = 0.5
		max_dist = 15
		DE_A()
			src.Explode(3, 500, src.owner)

