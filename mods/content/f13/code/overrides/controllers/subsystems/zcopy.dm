// There's a bug in zcopy, this is a stopgap override of its fire function until it gets fixed upstream.

/datum/controller/subsystem/zcopy/fire(resumed = FALSE, no_mc_tick = FALSE)
	if (!resumed)
		qt_idex = 1
		qo_idex = 1

	MC_SPLIT_TICK_INIT(2)
	if (!no_mc_tick)
		MC_SPLIT_TICK

	var/list/curr_turfs = queued_turfs
	var/list/curr_ov = queued_overlays

	while (qt_idex <= curr_turfs.len)
		var/turf/T = curr_turfs[qt_idex]
		curr_turfs[qt_idex] = null
		qt_idex += 1

		if (!isturf(T) || !(T.z_flags & ZM_MIMIC_BELOW) || !T.z_queued)
			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				break
			continue

		// If we're not at our most recent queue position, don't bother -- we're updating again later anyways.
		if (T.z_queued > 1)
			T.z_queued -= 1
			multiqueue_skips_turf += 1
			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				break
			continue

		// Z-Turf on the bottom-most level, just fake-copy space.
		// If this is ever true, that turf should always pass this condition, so don't bother cleaning up beyond the Destroy() hook.
		if (!T.below)	// Z-turf on the bottom-most level, just fake-copy space.
			if (T.z_flags & ZM_MIMIC_OVERWRITE)
				T.appearance = SSskybox.dust_cache["[((T.x + T.y) ^ ~(T.x * T.y) + T.z) % 25]"]
				T.name = initial(T.name)
				T.desc = initial(T.desc)
				T.gender = initial(T.gender)
			else
				// Some openturfs have icons, so we can't overwrite their appearance.
				if (!T.mimic_underlay)
					T.mimic_underlay = new(T)
				var/atom/movable/openspace/turf_proxy/TO = T.mimic_underlay
				TO.appearance = SSskybox.dust_cache["[((T.x + T.y) ^ ~(T.x * T.y) + T.z) % 25]"]
				TO.name = T.name
				TO.gender = T.gender	// Need to grab this too so PLURAL works properly in examine.
				TO.mouse_opacity = initial(TO.mouse_opacity)

			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				break
			continue

		if (!T.shadower)	// If we don't have a shadower yet, something has gone horribly wrong.
			WARNING("Turf [T] at [T.x],[T.y],[T.z] was queued, but had no shadower.")
			continue

		T.z_generation += 1

		// Get the bottom-most turf, the one we want to mimic.
		var/turf/Td = T
		while (Td.below)
			Td = Td.below

		// Depth must be the depth of the *visible* turf, not self.
		var/turf_depth
		turf_depth = T.z_depth = zlev_maximums[Td.z] - Td.z

		var/t_target = OPENTURF_MAX_PLANE - turf_depth	// This is where the turf (but not the copied atoms) gets put.

		// Handle space parallax & starlight.
		if (T.below.z_eventually_space)
			T.z_eventually_space = TRUE
			t_target = SPACE_PLANE

		if (T.z_flags & ZM_MIMIC_OVERWRITE)
			// This openturf doesn't care about its icon, so we can just overwrite it.
			if (T.below.mimic_proxy)
				QDEL_NULL(T.below.mimic_proxy)
			T.appearance = T.below
			T.dir = T.below.dir
			T.name = initial(T.name)
			T.desc = initial(T.desc)
			T.gender = initial(T.gender)
			T.opacity = FALSE
			T.plane = t_target
		else
			// Some openturfs have icons, so we can't overwrite their appearance.
			if (!T.below.mimic_proxy)
				T.below.mimic_proxy = new(T)
			var/atom/movable/openspace/turf_proxy/TO = T.below.mimic_proxy
			TO.appearance = T
			TO.dir = T.dir
			TO.name = T.name
			TO.gender = T.gender	// Need to grab this too so PLURAL works properly in examine.
			TO.opacity = FALSE
			TO.plane = t_target
			TO.mouse_opacity = initial(TO.mouse_opacity)

		T.queue_ao(T.ao_neighbors_mimic == null)	// If ao_neighbors hasn't been set yet, we need to do a rebuild

		// Explicitly copy turf delegates so they show up properly on below levels.
		//   I think it's possible to get this to work without discrete delegate copy objects, but I'd rather this just work.
		if ((T.below.z_flags & (ZM_MIMIC_BELOW|ZM_MIMIC_OVERWRITE)) == ZM_MIMIC_BELOW)
			// Below is a delegate, gotta explicitly copy it for recursive copy.
			if (!T.below.mimic_above_copy)
				T.below.mimic_above_copy = new(T)
			var/atom/movable/openspace/turf_mimic/DC = T.below.mimic_above_copy
			DC.appearance = T.below
			DC.mouse_opacity = initial(DC.mouse_opacity)
			DC.plane = OPENTURF_MAX_PLANE

		else if (T.below.mimic_above_copy)
			QDEL_NULL(T.below.mimic_above_copy)

		// Handle below atoms.

		// Add everything below us to the update queue.
		for (var/thing in T.below)
			var/atom/movable/object = thing
			if (QDELETED(object) || (object.z_flags & ZMM_IGNORE) || object.loc != T.below || object.invisibility == INVISIBILITY_ABSTRACT)
				// Don't queue deleted stuff, stuff that's not visible, blacklisted stuff, or stuff that's centered on another tile but intersects ours.
				continue

			// Special case: these are merged into the shadower to reduce memory usage.
			if (object.type == /atom/movable/lighting_overlay)
				T.shadower.copy_lighting(object)
				continue

			if (!object.bound_overlay)	// Generate a new overlay if the atom doesn't already have one.
				object.bound_overlay = new(T)
				object.bound_overlay.associated_atom = object

			var/override_depth
			var/original_type = object.type
			var/original_z = object.z
			switch (object.type)
				if (/atom/movable/openspace/mimic)
					var/atom/movable/openspace/mimic/OOO = object
					original_type = OOO.mimiced_type
					override_depth = OOO.override_depth
					original_z = OOO.original_z

				if (/atom/movable/openspace/turf_proxy, /atom/movable/openspace/turf_mimic)
					// If we're a turf overlay (the mimic for a non-OVERWRITE turf), we need to make sure copies of us respect space parallax too
					if (T.z_eventually_space)
						// Yes, this is an awful hack; I don't want to add yet another override_* var.
						override_depth = OPENTURF_MAX_PLANE - SPACE_PLANE

			var/atom/movable/openspace/mimic/OO = object.bound_overlay

			// If the OO was queued for destruction but was claimed by another OT, stop the destruction timer.
			if (OO.destruction_timer)
				deltimer(OO.destruction_timer)
				OO.destruction_timer = null

			OO.depth = override_depth || min(zlev_maximums[T.z] - original_z, OPENTURF_MAX_DEPTH)

			// These types need to be pushed a layer down for bigturfs to function correctly.
			switch (original_type)
				if (/atom/movable/openspace/multiplier, /atom/movable/openspace/turf_mimic, /atom/movable/openspace/turf_proxy)
					if (OO.depth < OPENTURF_MAX_DEPTH)
						OO.depth += 1

			OO.mimiced_type = original_type
			OO.override_depth = override_depth
			OO.original_z = original_z

			// Multi-queue to maintain ordering of updates to these
			//   queueing it multiple times will result in only the most recent
			//   actually processing.
			OO.queued += 1
			queued_overlays += OO

		T.z_queued -= 1
		if (T.above)
			T.above.update_mimic()

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (qt_idex > 1)
		curr_turfs.Cut(1, qt_idex)
		qt_idex = 1

	if (!no_mc_tick)
		MC_SPLIT_TICK

	while (qo_idex <= curr_ov.len)
		var/atom/movable/openspace/mimic/OO = curr_ov[qo_idex]
		curr_ov[qo_idex] = null
		qo_idex += 1

		if (QDELETED(OO) || !OO.queued)
			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				break
			continue

		if (QDELETED(OO.associated_atom))	// This shouldn't happen, but just in-case.
			qdel(OO)

			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				break
			continue

		// Don't update unless we're at the most recent queue occurrence.
		if (OO.queued > 1)
			OO.queued -= 1
			multiqueue_skips_object += 1
			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				break
			continue

		// Actually update the overlay.
		if (OO.dir != OO.associated_atom.dir)
			OO.set_dir(OO.associated_atom.dir)

		OO.appearance = OO.associated_atom
		OO.z_flags = OO.associated_atom.z_flags
		OO.plane = OPENTURF_MAX_PLANE - OO.depth

		OO.opacity = FALSE
		OO.queued = 0

		// If an atom has explicit plane sets on its overlays/underlays, we need to replace the appearance so they can be mangled to work with our planing.
		if (OO.z_flags & ZMM_MANGLE_PLANES)
			var/new_appearance = fixup_appearance_planes(OO.appearance)
			if (new_appearance)
				OO.appearance = new_appearance

		if (OO.bound_overlay)	// If we have a bound overlay, queue it too.
			OO.update_above()

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (qo_idex > 1)
		curr_ov.Cut(1, qo_idex)
		qo_idex = 1

