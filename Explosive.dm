var/EXPLOSION_OVERLAY = image(icon = 'icons/_Bullets.dmi', icon_state = "explosion", layer = MOB_LAYER, pixel_x = -8)

atom/movable/proc
	Explode(var/radius = 1, var/damage = 500, var/mob/player/client/O)
		src.overlays.Add(EXPLOSION_OVERLAY)
		de_sound(30, src.loc, SOUND_GRENADE)
		src.icon_state = null
		for(var/atom/movable/A in de_view(radius, src))
			if(!A||!A.density||A.is_dead) continue
			switch(A.rtype)
				if(3, 43)
					A.health -= damage
					switch(A.rtype)
						if(43)
							var/obj/enviroment/hazard/barrel/B = A
							if(!B.owner) if(O) B.owner = O
					if(A.health < 1)
						if(A.rtype == 3 && O && !O.is_dead)

							O.kills ++
							spawn() O.Kill_Check()
							O.exp ++
							O.rank_up()
						A.Death(, "Exploded", 1)
		spawn(5)
			src.overlays.Cut()
			if(src.rtype == 43)
				return
			if(src.is_garbage) src.GC()
			else del(src)

obj/enviroment/hazard
	barrel
		mouse_opacity = 0
		var
			mob/player/client/owner = null
			init_loc
		health = 50
		maxhealth = 50
		rtype = 43
		icon = 'icons/_Objects.dmi'
		icon_state = "barrel"
		density = 1
		layer = TURF_LAYER + 2
		glide_size = 2
		New()
			..()
			src.init_loc = src.loc
		Death()
			if(!src.is_dead)
				src.is_dead = 1
				src.Explode(2, 500, src.owner)
				spawn(1800) src.repop()

		proc/repop()
			src.loc = src.init_loc
			src.health = src.maxhealth
			src.icon_state = "barrel"
			src.density = 1
			src.is_dead = 0
