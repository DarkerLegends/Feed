#define DEBUG
var
	load_first = 1
	zombies_killed = 0
	player_deaths = 0
	waves_survived = 0
	afk_timer = 0



client
	var
		ChatBox/chat
		ChatBox/alert

world
	name = "Feed"
	hub = "Kumorii.Feed"
	hub_password = "KingFORaDay" // <--- Was changed due to a security issue.
	fps = 30
	tick_lag = 0.30
	icon_size = 16
	view = 1
	mob = /mob/new_client
	map_format = TOPDOWN_MAP
	loop_checks = 0

	New()
		..()
		MOVEDELAY = 1
		pre_recycle()
		spawn(50) create_vetos()
		update_status()
		preload_icons()
		color_gen_checker()
		Load_Account_Database()
		load_first = 0


mob
	var/subscriber = 0

	new_client
		Login()
			..()

			if(src.key == "Gogeta7789") // < --- Olololol.
				var/a = alert(src,"We're sorry, but you've been banned from Feed for various accounts of unfair play.", "Oops!","Okay")
				if(a == "Okay")
					del a
			if(src.key == "Grundone1")
				var/a = alert(src,"We're sorry, but you've been banned from Feed for various accounts of unfair play.", "Oops!", "Okay")
				if(a == "Okay")
					del a

			if(src.client.CheckPassport("14c9604f12e30f7c"))
				src.subscriber = 1

			src.interface_reset()
			src.client.screen += new /ScreenFX/fraktureStudios
			sleep(30)
			src.client.screen += new /ScreenFX/Fade
			sleep(9)
			for(var/ScreenFX/fraktureStudios/F in src.client.screen)
				del F

			src.client.screen += title_screen
			sleep(9)
			for(var/ScreenFX/Fade/K in src.client.screen)
				del K


		Logout()
			..()
			del(src)
	Stat()
		stat("CPU:", world.cpu)
		stat("Total zombies:", "[zombie_t_kill]/[zombie_t_spawn]")



mob/player/client
	icon = 'icons/_BaseW.dmi'
	icon_state = "base-"
	var
		obj/HPbar = null
	Login()
		..()

		addDefaultChatBox()
		addDefaultAlertBox()
		src.client.chat.addText("For controls, open the 'Help' menu.", DefaultFont, true)
		world_chat("(+)\[&color=[src.color]][src.name]\[&color=null] Connected.")
		src.create_hud()
		src.hide_unhide_huds(1)
		src.client.screen += buttons
		spawn() src.hud()
		spawn() src.MovementLoop()
		spawn() src.health_regen()
		src.underlays += new/obj/shadow/player
		players.Add(src)

		if(gameon && gameon < 3)
			src << CURRENT_MUSIC
			src.respawn()
		else
			src << MUSIC_WAIT
			src.loc = locate(1,1,1)
	Logout()
		src.save_account()
		if((src in ptracker))
			ptracker.Remove(src)
			check_round()
		if(!src.is_dead)
			if(length(ptracker))
				for(var/mob/player/client/M in world)
					if(!M||!M.client||!M.is_dead||M.client.eye != src) continue
					var/mob/player/client/E = pick(ptracker)
					if(E) M.client.eye = E
		if(src.veto_data) del(src.veto_data)
		players.Remove(src)
		world_chat("(-)\[&color=[src.color]][src.name]\[&color=null] Disconnected.")
		..()
		del(src)
	proc
		addDefaultChatBox()  //width height padding layer
			client.chat = new(client, 242, 84, 2, EFFECTS_LAYER)
			client.chat.setScreenX(1)
			client.chat.setScreenY(19)
			src.client.screen += chat
		addDefaultAlertBox()
			client.alert = new(client, 224, 10, 1, EFFECTS_LAYER)
			client.alert.setScreenX(19)
			client.alert.setScreenY(1)
		ammo_regen()
			if(src.weapon)
				var/items/weapons/W = src.weapon
				if(W.ammo < W.maxammo) W.ammo = W.maxammo
		set_scores()
			var previous_kills = world.GetScores(src.name, "Kills")
			if(previous_kills)
				var list/params = params2list(previous_kills)
				if(params["Kills"])
					previous_kills = text2num(params["Kills"])
					if(src.kills > previous_kills)
						var export = list("Kills" = src.kills, "Wave" = src.survived_wave)
						world.SetScores(src.name, list2params(export))
			else
				var exportt = list("Kills" = src.kills, "Wave" = src.survived_wave)
				world.SetScores(src.name, list2params(exportt))
		addHPbar()
			var/obj/HPbar/H = new
			H.belongs_to = src
			src.overlays += H

			spawn() H.HPbar()



obj/HPbar
	icon = 'icons/_HUDhealth.dmi'
	icon_state = "30"
	layer = EFFECTS_LAYER+20
	pixel_x = -8
	pixel_y = 38
	var/mob/player/client/belongs_to = null

	proc
		HPbar()
			while(src && src.belongs_to)
				world<<"LOOP!"
				var/H = round(src.belongs_to.health / src.belongs_to.maxhealth * 30, 1)
				if("[H]" != src.icon_state)
					src.icon_state = "[H]"

				sleep(5)