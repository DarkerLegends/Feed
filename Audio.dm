var/SOUND_WIND = sound('audio/sound/wind[edit].ogg',1, volume = 60, channel = 50)

var/SOUND_GRENADE = sound('audio/sound/grenade.ogg',0, volume = 60, channel = 10)
var/SOUND_GUNFIRE1 = sound('audio/sound/gun1.ogg',0, volume = 60, channel = 12)
var/SOUND_GUNFIRE2 = sound('audio/sound/gun2.ogg',0, volume = 60, channel = 12)
var/SOUND_SHOTGUN = sound('audio/sound/shotgun1.ogg',0, volume = 90, channel = 13)
var/SOUND_CROSSBOW = sound('audio/sound/crossbow1.ogg',0, volume = 90, channel = 14)

var/list/s_gun = list(SOUND_GUNFIRE1, SOUND_GUNFIRE2)

var/SOUND_ZGROWL1 = sound('audio/sound/growl1.ogg',0, volume = 60)
var/SOUND_ZGROWL2 = sound('audio/sound/growl2.ogg',0, volume = 60)

var/SOUND_CLICK = sound('audio/sound/click.ogg',0, volume = 100)

var/SOUND_WAVE_BEGINING = sound('audio/sound/voice_wave_begin.ogg',0, volume = 60)
var/SOUND_WAVE_COMPLETE = sound('audio/sound/voice_wave_complete.ogg',0, volume = 62)
var/SOUND_ACHIEVEMENT_U = sound('audio/sound/voice_au.ogg',0, volume = 60)
var/SOUND_ALL_PLAYERS_DEAD = sound('audio/sound/voice_all_players_dead.ogg',0, volume = 60)

var/list/s_growl = list(SOUND_ZGROWL1, SOUND_ZGROWL2)



//var/MUSIC_TITLE = sound('music/title.ogg',0,volume = 30, channel = 3)
var/MUSIC_WAIT = sound('audio/music/wait.ogg',1,volume = 30, channel = 3)

var/list/MUSIC_SOUNDTRACK = list(MUSIC_SIMPLY_NO_CHANCE, MUSIC_NO_WHERE_TO_RUN, MUSIC_FIVE, MUSIC_TWO, MUSIC_THREE)
var/list/M_CYCLE = list()

var/MUSIC_SIMPLY_NO_CHANCE = sound('audio/music/simply_no_chance[loop].ogg',1,volume = 30, channel = 3)
var/MUSIC_NO_WHERE_TO_RUN = sound('audio/music/no_where_to_run[loop].ogg',1,volume = 30, channel = 3)
var/MUSIC_FIVE = sound('audio/music/five.ogg',1,volume = 30, channel = 3)
var/MUSIC_TWO = sound('audio/music/two.ogg',1,volume = 30, channel = 3)
var/MUSIC_THREE = sound('audio/music/three.ogg',1,volume = 30, channel = 3)

var/CURRENT_MUSIC = null

proc/Cycle_Music()
	CURRENT_MUSIC = pick(MUSIC_SOUNDTRACK)