/obj/effect/daynight
	var/lightlevel				= 0 //This default makes turfs not generate light.
	var/initial_lightlevel 		= 0.7
	var/night					= TRUE // Is it currently night time?
	var/last_night				= 0 // Ticks of the last night
	var/last_day				= 0 // Ticks of the last day
	var/day_lightlevel			= 1 // Daytime light level
	var/night_lightlevel		= 0.1 // Night light level
	var/light_increment			= 0.1 // Amount light decreases or increases per step
	var/night_duration   		= 10 MINUTES // How many ticks does the night last?
	var/day_duration			= 10 MINUTES // How many ticks does the day last?
	var/daycycle				// Ticks total for a day, computed by night_duration + day_duration
	var/daycolumn 				= 0 //Which column's light needs to be updated next?
	var/daycycle_column_delay 	= 1 SECONDS // Amount of time each slice of the world takes to update its light value. 0 for 'fast as possible'
	var/daycycle_column_amount  = 3 // Amount of columns to update at once
	var/map_z 					= list()

/obj/effect/daynight/Initialize()
	. = ..()
	daycycle = day_duration + night_duration
	map_z = global.using_map.player_levels
	lightlevel = initial_lightlevel
	START_PROCESSING(SSobj, src)

/obj/effect/daynight/Process(wait, tick)
	if(daycycle)
		if(night)
			if(tick % round(night_duration / wait) == 0)
				night = !night
				daycolumn = 1
		else
			if(tick % round(day_duration / wait) == 0)
				night = !night
				daycolumn = 1
		if(daycolumn)
			if(daycycle_column_delay)
				if(tick % round(daycycle_column_delay / wait) == 0)
					update_daynight()
			else
				update_daynight()

/obj/effect/daynight/proc/update_daynight()
	var/real_amount = daycycle_column_amount
	if(daycolumn + daycycle_column_amount > world.maxy)
		real_amount = world.maxy - daycolumn

	var/turf/firstturf = locate(daycolumn,1,min(map_z))
	var/turf/secondturf = locate(daycolumn+real_amount,world.maxy,max(map_z))
	for(var/turf/exterior/T in block(firstturf,secondturf))
		T.set_light(1, lightlevel)
	daycolumn += real_amount
	if(daycolumn >= world.maxy)
		daycolumn = 0
	if(night)
		if(lightlevel > night_lightlevel && daycolumn == 0)
			lightlevel -= light_increment
			daycolumn = 1
	else
		if(lightlevel < day_lightlevel && daycolumn == 0)
			lightlevel += light_increment
			daycolumn = 1
