/turf/exterior/f13 // Base turf for external turfs. Do not use directly.
	name = "\improper F13 Ground"
	icon = 'mods/content/f13/icons/turf/desert.dmi'

/turf/exterior/update_ambient_light(mapload)
	set_light(global.using_map.initial_lightlevel)