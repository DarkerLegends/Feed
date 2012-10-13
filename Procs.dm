

var/DE_DVIEW = 3
var/VERSION = "v.2.4.2"

proc
	de_view(var/range = DE_DVIEW, var/atom/A)
		if(A && range > 0)
			if(range > DE_DVIEW) range = DE_DVIEW
			var/list/L = list()
			var/sx = (A.x - range)
			if(sx < 1) sx = 1
			var/sy = (A.y - range)
			if(sy < 1) sy = 1
			var/ex = (A.x + range)
			if(ex > world.maxx) ex = world.maxx
			var/ey = (A.y + range)
			if(ey > world.maxy) ey = world.maxy
			for(var/turf/T in block(locate(sx, sy, A.z),locate(ex, ey, A.z)))
				if(T && isturf(T))
					L += T
					if(length(T.contents))
						L += T.contents
			return L
	de_sound(var/range = DE_DVIEW, var/atom/A, var/sound/sfile)
		if(sfile)
			for(var/mob/player/client/M in players)
				if(!M||!M.gamein) continue
				var/s_dist = get_dist(M, A)
				if(s_dist <= range) M << sfile
	update_status()
		var/status = "Starting"
		var/hst = world.host
		if(!hst) hst = "Unknown"
		if(hst == "Unknown")
			if(isOfficial())	hst = "Official Server"
			else if(isOfficial2())	hst = "Official Server 2"
		if(gameon) status = "Game in progress"
		world.status = {"<font size=1>[hst]</font>]
					<font size=1><b><u>Feed:</u>{[VERSION]}</b>
					<b>Map: </b>[current_map]
					<b>Status: </b>[status]
					\[<b>Wave: </b>[wave]"}
		if(gameon)
			world.name = "Feed | Wave: [wave]"
		else
			world.name = "Feed"
	isOfficial()
		if(world.internet_address == "67.210.108.209")
			return 1
		else
			return 0

	isOfficial2()
		if(global.isserver2 == 1)
			return 1
		else
			return 0

var/isserver2 = 0