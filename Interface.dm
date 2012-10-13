var/list/title_screen = newlist(/Title/Background, /Title/JoinGame, /Title/Credits)
var/wave_complete = newlist(/ScreenFX/wave_done)
var/spectate_stuff = newlist(/ScreenFX/spectate)
var/buttons = newlist(/ScreenFX/Help, /ScreenFX/Customize, /ScreenFX/ToggleChat, /ScreenFX/NameGreen, /ScreenFX/NameRed, /ScreenFX/NameBlue, /ScreenFX/NamePurple)
var/MenuBG = new /ScreenFX/MenuBG
var/TitleMenuBG = new /ScreenFX/TitleMenuBG
var/Rain = newlist(/ScreenFX/Rain, /ScreenFX/Rain/R2, /ScreenFX/Rain/R3, /ScreenFX/Rain/R4, /ScreenFX/Rain/R5, /ScreenFX/Rain/R6, \
					/ScreenFX/Rain/R7, /ScreenFX/Rain/R8, /ScreenFX/Rain/R9, /ScreenFX/Rain/R10)
var/chat = newlist(/ScreenFX/chatBG, /ScreenFX/chatBGright, /ScreenFX/chatBGbottom, /ScreenFX/chatBGcorner)
var/outbreak = new /ScreenFX/outbreak
Title
	parent_type = /obj

	Background
		icon = 'Background.png'
		screen_loc = "map_title:1,1"
	JoinGame
		mouse_opacity = 2
		icon = '_Connect.dmi'
		icon_state = "off"
		screen_loc = "map_title:13:5,5:4"
		MouseEntered()
			..()
			usr << SOUND_CLICK
			src.icon_state = "on"
		MouseExited()
			..()
			src.icon_state = "off"
		Click()
			..()
			var/mob/M = usr
			if(M.type == /mob/new_client)
				var/mob/new_client/N = M
				//N.connect_server()
				N.login_server()
	Credits
		mouse_opacity = 2
		icon = '_Credit.dmi'
		icon_state = "off"
		screen_loc = "map_title:13:13,3:8"
		MouseEntered()
			..()
			usr << SOUND_CLICK
			src.icon_state = "on"
		MouseExited()
			..()
			src.icon_state = "off"
		Click()
			..()
			usr.client.screen += TitleMenuBG
			winset(usr, null, "menuchild.left=\"creditpane\"")
			winshow(usr, "menuchild", 1)
ScreenFX
	parent_type = /obj
	wave_done
		mouse_opacity = 0
		icon = 'wave_done.png'
		screen_loc = "1,1"
		layer = EFFECTS_LAYER+50
	outbreak
		mouse_opacity = 0
		icon = 'outbreak.png'
		screen_loc = "1,1"
		layer = EFFECTS_LAYER+50
	chatBG
		mouse_opacity = 0
		icon = 'icons/__16x16.dmi'
		icon_state = "chatBG"
		screen_loc = "1,20 to 15,15"
		layer = EFFECTS_LAYER
	chatBGright
		mouse_opacity = 0
		icon = 'icons/__16x16.dmi'
		icon_state = "chatBG-right"
		screen_loc = "16,20 to 16,15"
		layer = EFFECTS_LAYER
	chatBGbottom
		mouse_opacity = 0
		icon = 'icons/__16x16.dmi'
		icon_state = "chatBG-bottom"
		screen_loc = "1,14 to 15,14"
		layer = EFFECTS_LAYER
	chatBGcorner
		mouse_opacity = 0
		icon = 'icons/__16x16.dmi'
		icon_state = "chatBG-corner"
		screen_loc = "16,14"
		layer = EFFECTS_LAYER
	spectate
		mouse_opacity = 0
		icon = 'spectate.png'
		screen_loc = "1,1"
		layer = EFFECTS_LAYER+50
	Hurt
		mouse_opacity = 0
		icon = 'Hurt.png'
		layer = EFFECTS_LAYER+50
		screen_loc = "1,1"
	fraktureStudios
		layer = EFFECTS_LAYER
		icon = 'frakture_studios.png'
		screen_loc = "map_title:1,1"
	Fade
		layer = EFFECTS_LAYER+50
		icon = 'icons/_Effects.dmi'
		icon_state = "fade"
		screen_loc = "map_title:1,1 to 30,20"
	Help
		icon = 'Help.dmi'
		icon_state = "off"
		screen_loc = "29:6,20"
		mouse_opacity = 2
		layer = EFFECTS_LAYER+99
		MouseEntered()
			..()
			src.icon_state = "on"
		MouseExited()
			..()
			src.icon_state = "off"
		Click()
			..()
			usr.client.screen += MenuBG
			winset(usr, null, "menuchild.left=\"helppane\"")
			winshow(usr, "menuchild", 1)
			usr.overlays += 'busy.dmi'
	Customize
		icon = 'Customize.dmi'
		icon_state = "off"
		screen_loc = "25:9,20:1"
		mouse_opacity = 2
		layer = EFFECTS_LAYER+99
		MouseEntered()
			..()
			src.icon_state = "on"
		MouseExited()
			..()
			src.icon_state = "off"
		Click()
			..()
			usr.client.screen += MenuBG
			winset(usr, null, "menuchild.left=\"custompane\"")
			winshow(usr, "menuchild", 1)
			usr.overlays += 'busy.dmi'

	NameGreen
		mouse_opacity = 1
		icon = 'icons/_Menu.dmi'
		icon_state = "name-green"
		screen_loc = "1:2,14:-3"
		layer = EFFECTS_LAYER+10
		Click()
			..()
			var/mob/player/client/C = usr
			C.color = "#00FF00"
			src.icon_state = "name-green!"
			spawn(3)
				src.icon_state = "name-green"

			C.save_account()
			C.generate_icon()

	NameRed
		mouse_opacity = 1
		icon = 'icons/_Menu.dmi'
		icon_state = "name-red"
		screen_loc = "1:3,14:-3"
		layer = EFFECTS_LAYER+10
		Click()
			..()
			var/mob/player/client/C = usr
			C.color = "#FF3333"
			src.icon_state = "name-red!"
			spawn(3)
				src.icon_state = "name-red"

			C.save_account()
			C.generate_icon()
	NameBlue
		mouse_opacity = 1
		icon = 'icons/_Menu.dmi'
		icon_state = "name-blue"
		screen_loc = "2:4,14:-3"
		layer = EFFECTS_LAYER+10
		Click()
			..()
			var/mob/player/client/C = usr
			C.color = "#1C86EE"
			src.icon_state = "name-blue!"
			spawn(3)
				src.icon_state = "name-blue"

			C.save_account()
			C.generate_icon()
	NamePurple
		mouse_opacity = 1
		icon = 'icons/_Menu.dmi'
		icon_state = "name-purple"
		screen_loc = "2:5,14:-3"
		layer = EFFECTS_LAYER+10
		Click()
			..()
			var/mob/player/client/C = usr
			C.color = "#FF00FF"
			src.icon_state = "name-purple!"
			spawn(3)
				src.icon_state = "name-purple"

			C.save_account()
			C.generate_icon()

	ToggleChat
		mouse_opacity = 1
		icon = 'icons/_Menu.dmi'
		icon_state = "chat-add-on"
		screen_loc = "3:6,14:-3"
		layer = EFFECTS_LAYER+10
		Click()
			..()
			if(usr.chat_on)
				src.icon_state = "chat-add-off"
				usr.client.chat.hide()
				usr.client.screen -= chat
				usr.chat_on = 0
				usr.chat_buttons(1)
			else
				src.icon_state = "chat-add-on"
				usr.client.chat.show()
				usr.client.screen += chat
				usr.chat_on = 1
				usr.chat_buttons(0)

	MenuBG
		icon = '_Menu.dmi'
		icon_state = "bg"
		layer = EFFECTS_LAYER+100
		screen_loc = "NORTHWEST to SOUTHEAST"
		mouse_opacity = 2
	TitleMenuBG
		icon = '_Menu.dmi'
		icon_state = "bg"
		layer = EFFECTS_LAYER+100
		screen_loc = "map_title:1,1 to 30,20"
		mouse_opacity = 2
	Loadscreen
		icon = 'loadscreen.dmi'
		layer = EFFECTS_LAYER-1
	Respawn
		icon = 'Respawn.dmi'
		layer = EFFECTS_LAYER+50
		screen_loc = "13,12"
	Rain
		icon = '__96x96.dmi'
		icon_state = "rain"
		layer = EFFECTS_LAYER+50
		screen_loc = "1,1"
		R2/screen_loc = "7,1"
		R3/screen_loc = "13,1"
		R4/screen_loc = "19,1"
		R5/screen_loc = "25,1"
		R6/screen_loc = "1,7"
		R7/screen_loc = "7,7"
		R8/screen_loc = "13,7"
		R9/screen_loc = "19,7"
		R10/screen_loc = "25,7"

mob/player/client/proc
	remove_hurt()
		for(var/ScreenFX/Hurt/H in src.client.screen)
			del H
mob/new_client
	var/tmp/connected = 0
	proc
		interface_reset()
			winset(src, "main_splitter","left=title_window;right=")
			winset(src, "main_window","macro=new")
			//winset(src, "main_window", "menu=")
		connect_server()
			set category = null
			if(!src.connected)
				src.connected = 1
				src.client.screen -= title_screen
				winset(src, "main_splitter","left=map_window;right=")
				winset(src, "main_window","macro=macro")
				//src.load_save()
		login_server()
			set category = null
			src.connected = 1
			src.client.screen -= title_screen
			winset(src, "main_splitter","left=log_reg_window;right=")
	verb
		close_news()
			winshow(usr,"menuchild",0)