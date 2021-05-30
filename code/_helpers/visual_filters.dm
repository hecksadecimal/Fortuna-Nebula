// These involve BYOND's built in filters that do visual effects, and not stuff that distinguishes between things.

// All of this ported from TG.
// And then ported to Nebula from Polaris.
/atom/movable
	var/list/filter_data // For handling persistent filters

/proc/cmp_filter_data_priority(list/A, list/B)
	return A["priority"] - B["priority"]

/atom/movable/proc/add_filter(filter_name, priority, list/params)
	LAZYINITLIST(filter_data)
	var/list/p = params.Copy()
	p["priority"] = priority
	filter_data[filter_name] = p
	update_filters()

/atom/movable/proc/update_filters()
	filters = null
	filter_data = sortTim(filter_data, /proc/cmp_filter_data_priority, TRUE)
	for(var/f in filter_data)
		var/list/data = filter_data[f]
		var/list/arguments = data.Copy()
		arguments -= "priority"
		filters += filter(arglist(arguments))
	UPDATE_OO_IF_PRESENT

/atom/movable/proc/get_filter(filter_name)
	if(filter_data && filter_data[filter_name])
		return filters[filter_data.Find(filter_name)]

// Polaris Extensions
/atom/movable/proc/remove_filter(filter_name)
	var/thing = get_filter(filter_name)
	if(thing)
		LAZYREMOVE(filter_data, filter_name)
		filters -= thing
		update_filters()