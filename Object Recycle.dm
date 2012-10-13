var/objectPool/main_type/garbage = new/objectPool/main_type
var/const/ORECYCLE = 800

proc
	pre_recycle()
		var/list/L = typesof(/obj/projectiles)
		L -= /obj/projectiles
		L += /obj/effects/corpse
		L += /obj/effects/blood
		L += /obj/effects/body_part
		L += /obj/effects/bullet_left_overs
		L += /obj/triggys/hazards/fire
		L += /obj/triggys/hazards/vomit
		L += /mob/enemys/zombie
		L += /mob/enemys/puker
		L += /mob/enemys/spectre
		L += /obj/effects/de_damage_text
		for(var/T in L)
			var/objectPool/sub_type/O = new/objectPool/sub_type
			for(var/i = 1, i <= ORECYCLE, i++) O.npool += new T
			garbage.pool[T] = O

objectPool
	sub_type
		var/npool[0]
	main_type
		var/pool[0]
		proc
			Add(atom/movable/A)
				var/objectPool/sub_type/R = src.pool[A.type]
				if(R)
					if(!(A in R.npool))
						R.npool += A
				else
					src.pool[A.type] = new/objectPool/sub_type
					R = src.pool[A.type]
					if(A)
						if(!(A in R.npool))
							R.npool += A
			Grab(var/type)
				var/atom/G = null
				var/objectPool/sub_type/A = src.pool[type]
				if(A)
					if((A.npool.len > 0))
						G = A.npool[1]
						A.npool -= G
					else G = new type
				else
					src.pool[type] = new/objectPool/sub_type
					G = new type
				return G