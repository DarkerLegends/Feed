var/list/official_maps = newlist(/dmm/streetside,/dmm/theatre,/dmm/evacuate,/dmm/autobahn,/dmm/escapeplan,/dmm/hallowed)
var/list/maps_played = new/list()
var/map_loading = 0
var/current_map = "Unknown"

dmm
	parent_type = /datum
	var/tmp{name = null;dmm_map = null;option_at = 0;option_is = 0} //option_is = number of zombies the map starts off with.
	streetside
		name = "Streetside"
		dmm_map = 'official_maps/Streetside.dmm'
		option_is = 50
	evacuate
		name = "Evacuate"
		dmm_map = 'official_maps/Evacuate.dmm'
		option_is = 90
	theatre
		name = "Theatre"
		dmm_map = 'official_maps/Theatre.dmm'
		option_is = 60
	autobahn
		name = "Autobahn"
		dmm_map = 'official_maps/Autobahn.dmm'
		option_is = 150
	escapeplan
		name = "Escape Plan"
		dmm_map = 'official_maps/Escape Plan.dmm'
		option_is = 50
	hallowed
		name = "Hallowed"
		dmm_map = 'official_maps/Hallowed.dmm'
		option_is = 90

var/veto_on = 0
var/veto_windows = 0

var/vetos = 0
var/mvetos = 0

voters
	parent_type = /datum
	New()
		mvetos++
		veto_windows++
		..()
	Del()
		veto_windows--
		..()

mob/player/client
	var
		voters/veto_data = null
	verb
		veto()
			if(veto_on)
				if(src.veto_data)
					vetos++
					world_alert("[src] vetoed.", FadeFont, true)
					del(src.veto_data)
					src.veto_data = null

proc/create_vetos()
	while(length(players) <= 0) sleep(10)
	mvetos = 0
	var/voted = 0
	var/dmm/P = null
	again
	var/list/L = list()
	L += official_maps
	for(var/dmm/D in L)
		if((D in maps_played)) L -= D
	if(!length(L)){maps_played = new/list();goto again}
	P = pick(L)
	if(!voted)
		for(var/mob/player/client/M in world)
			if(!M) continue
			M.veto_data = new/voters
		veto_on = 1

		world_chat("\[&color=#C0C0C0]'[P.name]' selected. You have 30 seconds to veto(F1) this map.")
		var/counter = 30
		while(veto_windows && counter > 0)
			counter --
			sleep(10)
		for(var/voters/V in world)
			if(!V) continue
			del(V)
		veto_on = 0
		if(vetos > 0)
			if(vetos > (mvetos/2))
				world_chat("\[&color=#C0C0C0]Map dismissed.")
				maps_played += P
				voted = 1
				vetos = 0
				goto again
			else vetos = 0
	maps_played += P
//	while(length(players) <= 0) sleep(10)           Moved this up there. ^

	map_loading = 1
	var/dmm/D = P.dmm_map
	current_map = "[P.name]"
	world_alert("Loading the map '[P.name]'")
	var/dmm_suite/new_reader = new()
	new_reader.load_map(D)
	Cycle_Music()
	DE_Weather()
	gameon = 1
	map_loading = 0
	update_status()

	if(P.option_at) auto_target = 1

	zombie_t_spawn = (length(players) * 2) + rand(10, 15) + P.option_is
	zombie_t_kill = zombie_t_spawn
	for(var/mob/player/client/C in world)
		if(!C) continue
		C.respawn()

	world_chat("\[&color=#FF0000]Wave will begin in 10 seconds.")
	var/rc = "[round]"
	spawn(100)
		if(rc == "[round]")
			if(!gameover)
				world_chat("\[&color=#C0C0C0]Wave beginning.")
				players << SOUND_WAVE_BEGINING
				players << CURRENT_MUSIC
				spawn() spawner(espawn_zone, erise_zone)