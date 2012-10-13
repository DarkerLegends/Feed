mob/player/client
	proc
		cycle_primary_proc()
			if(src.gamein)
				if(length(src.contents))
					if(!src.weapon)
						if(!src.wait_delay)
							src.wait_delay = 1
							spawn(10) src.wait_delay = 0
							src.weapon = src.contents[1]
					else
						if(length(src.contents) > 1)
							if(!src.wait_delay)
								src.wait_delay = 1
								spawn(10) src.wait_delay = 0
								var/items/I = src.contents[1]
								if(I)
									src.contents -= I
									src.contents += I
									src.weapon = src.contents[1]
									src.icon_state = src.weapon.i_state
									if(src.weapon_hud) src.weapon_hud.icon = src.weapon.hud_icon
	verb
		attack()
			set category = null
			if(!gameover)
				if(src.gamein)
					if(src.weapon)
						var/items/weapons/W = src.weapon
						if(W.weapon_type == "melee")
							if(!src.wait_delay)
								src.wait_delay = 1
								flick("base-[W.name]-attack",src)
								de_sound(30, src.loc, W.fire_sound)
								spawn(W.fr) src.wait_delay = 0

								for(var/mob/enemys/E in oview(src,1))
									if(src.dir == get_dir(src, E))
										var/dmg = rand(W.fp-8, W.fp+10)
										D_damage(E, "[dmg]")
										E.health -= dmg

										if(prob(50))
											var/obj/effects/blood/O = garbage.Grab(/obj/effects/blood)
											if(O){O.icon_state = "blood[rand(1,5)]";O.loc = E.loc;O.DE_EO()}

										if(E.health <= 0)
											if(src)
												src.kills += E.score
												src.exp += E.score*3
											E.Death()
											src.rank_up()

						else
							if(!src.escape_hit)
								if(src.weapon.clip > 0)
									if(!src.wait_delay)
										src.wait_delay = 1
										W.clip --
										flick("base-[W.name]-attack",src)
										de_sound(30, src.loc, W.fire_sound)
										spawn(W.fr) src.wait_delay = 0
										var/obj/projectiles/O = garbage.Grab(W.projectile)
										if(O)
											O.dir = src.dir
											O.owner = src
											O.damage = rand(W.fp - 8, W.fp + 8)
											if(src.subscriber) O.damage += round(O.damage/4)
											O.loc = src.loc
											spawn() O.DE_L()
										if(W.blois)
											var/obj/effects/bullet_left_overs/B = garbage.Grab(/obj/effects/bullet_left_overs)
											if(B)
												B.icon_state = "[W.blois][rand(1,4)]"
												B.loc = src.loc
												//B.last_loc.overlays += B
												B.DE_EO()
								else
									if(src.weapon.ammo) src.reload()
		reload()
			set category = null
			if(!gameover)
				if(src.gamein)
					if(src.weapon)
						if(!src.escape_hit)
							if(src.weapon.clip < src.weapon.maxclip)
								if(src.weapon.ammo > 0)
									if(!src.wait_delay)
										src.wait_delay = 1
										var/items/weapons/W = src.weapon
										var/take = W.maxclip
										take -= W.clip
										if(take > W.ammo) take = W.ammo
										if(W.rls)
											var/reload_time = (W.rs / 3)
											for(var/i = 1, i <= take, i++)
												if(!W||!src.gamein||src.escape_hit||(src.weapon != W)) break
												W.clip ++
												W.ammo --
												sleep(reload_time)
										else
											sleep(W.rs)
											if(W && src.gamein && !src.escape_hit)
												if(!(src.weapon != W))
													W.ammo -= take
													W.clip += take
										src.wait_delay = 0
		say()
			set category = null
			var/t=input("What would you like to say?","World Chat")as text | null
			t = copytext(t,1,100)
			if(!length(t)) return
			if(usr.ID in global.idmutelist)	return //---New Mute list
			world_chat("[rank_emblem]\[&color=[src.color]][src.name]\[&color=null]: [t]")

		interact()
			for(var/atom/A in oview(1))
				if(A.does_stuff)
					if(get_dir(src,A) == src.dir)
						world<<"OH"
						A.Function(src)

		use_secondary()
			set category = null
			if(!gameover)
				if(src.gamein)
					if(src.secondary_selected)
						if(length(src.secondary_items))
							var/items/secondary_items/I = src.secondary_items["[src.secondary_selected]"]
							if(I)
								if(I.no_proj)
									if(!src.wait_delay)
										src.wait_delay = 1
										spawn(6) src.wait_delay = 0
								//		flick("base-[I.icon_state]", src)
										I.ammount--
										spawn(3)
											var/obj/triggys/hazards/M = garbage.Grab(I.projectile)
											if(M)
												M.owner = src
												M.loc = src.loc
												M.icon_state = I.icon_state
											if(I.ammount < 1)
												src.secondary_items -= "[src.secondary_selected]"
												if(length(src.secondary_items) > 0)
													src.secondary_selected = src.secondary_items[1]
												else src.secondary_selected = null
												del(I)

								if(!src.escape_hit)
									if(!src.wait_delay)
										src.wait_delay = 1
										spawn(10) src.wait_delay = 0
										flick("base-[I.icon_state]", src)
										var/dirs = src.dir
										I.ammount--
										spawn(3)
											var/obj/projectiles/O = garbage.Grab(I.projectile)
											if(O)
												O.dir = dirs
												O.owner = src
												O.loc = src.loc
												spawn() O.DE_L()
											if(I.ammount < 1)
												src.secondary_items -= "[src.secondary_selected]"
												if(length(src.secondary_items) > 0)
													src.secondary_selected = src.secondary_items[1]
												else src.secondary_selected = null
												del(I)
		cycle_primary()
			set category = null
			if(src.gamein)
				if(length(src.contents))
					if(!src.weapon)
						if(!src.wait_delay)
							src.wait_delay = 1
							spawn(10) src.wait_delay = 0
							src.weapon = src.contents[1]
					else
						if(length(src.contents) > 1)
							if(!src.wait_delay)
								src.wait_delay = 1
								spawn(10) src.wait_delay = 0
								var/items/I = src.contents[1]
								if(I)
									src.contents -= I
									src.contents += I
									src.weapon = src.contents[1]
									src.icon_state = src.weapon.i_state
									if(src.weapon_hud) src.weapon_hud.icon = src.weapon.hud_icon
		cycle_secondary()
			set category = null
			if(src.gamein)
				if(length(src.secondary_items))
					if(!src.secondary_selected)
						if(!src.wait_delay)
							src.wait_delay = 1
							spawn(10) src.wait_delay = 0
							src.secondary_selected = src.secondary_items[1]
					else
						if(length(src.secondary_items) > 1)
							if(!src.wait_delay)
								src.wait_delay = 1
								spawn(10) src.wait_delay = 0
								var/items/I = src.secondary_items["[src.secondary_items[1]]"]
								src.secondary_items -= "[I.name]"
								src.secondary_items["[I.name]"] = I
								src.secondary_selected = src.secondary_items[1]


mob
	var/chat_on = 1
	verb
		admin_panel()
			set hidden = 1
			var/verify = input(usr, "Please verify.", "Verify") as text|null
			if(verify == "FeedStaffPass")
				usr.verbs += typesof(/gm/verb)
				winshow(usr, "admin_panel", 1)
		closemainmenu()
			set hidden = 1
			winshow(src, "menuchild", 0)
			usr.client.screen -= MenuBG
			usr.overlays -= 'busy.dmi'
		closetitlemainmenu()
			set hidden = 1
			winshow(src, "menuchild", 0)
			usr.client.screen -= TitleMenuBG

	proc
		chat_buttons(var/i as num)
			if(i)
				for(var/ScreenFX/ToggleChat/K in src.client.screen)
					K.screen_loc = "3:6,20:-3"
				for(var/ScreenFX/NameGreen/L in src.client.screen)
					L.screen_loc = "1:2,20:-3"
				for(var/ScreenFX/NameRed/L in src.client.screen)
					L.screen_loc = "1:3,20:-3"
				for(var/ScreenFX/NameBlue/L in src.client.screen)
					L.screen_loc = "2:4,20:-3"
				for(var/ScreenFX/NamePurple/L in src.client.screen)
					L.screen_loc = "2:5,20:-3"
			else
				for(var/ScreenFX/ToggleChat/K in src.client.screen)
					K.screen_loc = "3:6,14:-3"
				for(var/ScreenFX/NameGreen/L in src.client.screen)
					L.screen_loc = "1:2,14:-3"
				for(var/ScreenFX/NameRed/L in src.client.screen)
					L.screen_loc = "1:3,14:-3"
				for(var/ScreenFX/NameBlue/L in src.client.screen)
					L.screen_loc = "2:4,14:-3"
				for(var/ScreenFX/NamePurple/L in src.client.screen)
					L.screen_loc = "2:5,14:-3"
gm
	parent_type = /obj
	verb
		Shutdown_World()
			set category = "Admin"
			set name = "World Shutdown"
			world.Del()
		World_Reboot()
			set category = "Admin"
			set name = "World Reboot"
			world.Reboot()
		Boot()
			set category = "Admin"
			set name = "Boot"
			var/list/people = list()
			for(var/mob/player/client/C in world)
				if(C == usr) continue
				if(C)
					people += C
			var/mob/player/client/M = input(usr, "Who would you like to boot?", "Boot")as anything in people | null
			if(M)
				world_chat("[M] was booted by [usr].")
				del M
		Clear_Scoreboard()
			set category = "Admin"
			if(usr.key == "Kumorii")
				var/A = alert(usr,"Are you sure?","Clear Scoreboard?","Yes","No")
				if(A == "Yes")
					var/keys = world.GetScores(135, "Kills")
					if(keys)
						var/list/params = params2list(keys)
						world<<"<b>Players</b>"
						for(var/i=1, i<params.len, ++i)
							var/player = params[i]
							world<<"[i]. [player]"
						for(var/i=1, i<params.len, ++i)
							var/M = params[i]
							world<<"Clearing [M].."
							world.SetScores(M)

		Float()
			set category = "Admin"
			set name = "Float/Solidify"
			var/list/people = list()
			for(var/mob/player/client/C in world)
				if(C)
					people += C
			var/mob/player/client/M = input(usr, "Who would you like to let float?", "Float")as anything in people | null
			if(M)
				if(M.density)
					world_chat("[M] has been given float by [usr].")
					M.density = 0
				else
					world_chat("[M] was solidified by [usr].")
					M.density = 1

		Official_Server_2()
			set category = "Admin"
			global.isserver2 = 1
