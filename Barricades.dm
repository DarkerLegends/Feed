Tiles
	Barricades
		parent_type = /obj
		icon = 'icons/__32x32.dmi'
		rtype = 45
		var
			pushing
			need_pushing
			pulling
			big = 0
		Cone
			icon_state = "cone1"
			layer = TURF_LAYER+0.6
			density = 1
			de_dignore = 1
			health = 30
		Crate
			icon = 'icons/__new32x32.dmi'
			icon_state = "crate1"
			layer = TURF_LAYER+0.6
			density = 1
			de_dignore = 1
			health = 50
			Death()
				src.icon_state = "crate1-broken"
				src.density = 0
		Crate2
			icon = 'icons/__new32x32.dmi'
			icon_state = "crate2"
			bound_width = 32
			bound_height = 32
			layer = TURF_LAYER+0.6
			density = 1
			de_dignore = 1
			health = 150

			big = 1
			need_pushing = 2

			Death()
				src.icon_state = "crate2-broken"
				src.density = 0