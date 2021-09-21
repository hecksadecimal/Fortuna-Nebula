/obj/effect/daynight
	var/lightlevel = 0 		//This default makes turfs not generate light. Adjust to have exoplanents be lit.
	var/night = TRUE
	var/daycycle 			//How often do we change day and night
	var/daycolumn = 0 		//Which column's light needs to be updated next?
	var/daycycle_column_delay = 10 SECONDS
	var/map_z = list()

/obj/effect/daynight/Initialize()
	. = ..()
	map_z = global.using_map.player_levels
	daycycle = global.using_map.daycycle
	daycycle_column_delay = global.using_map.daycycle_column_delay
	lightlevel = global.using_map.initial_lightlevel

/obj/effect/daynight/Process(wait, tick)
	if(daycycle)
		if(tick % round(daycycle / wait) == 0)
			night = !night
			daycolumn = 1
		if(daycolumn && tick % round(daycycle_column_delay / wait) == 0)
			update_daynight()

/obj/effect/daynight/proc/update_daynight()
	var/light = 0.1
	if(!night)
		light = lightlevel
	to_world_log("LIGHT LEVEL [light]")
	for(var/turf/exterior/T in block(locate(daycolumn,1,min(map_z)),locate(daycolumn,world.maxy,max(map_z))))
		T.set_light(light)
	daycolumn++
	if(daycolumn > world.maxx)
		daycolumn = 0

