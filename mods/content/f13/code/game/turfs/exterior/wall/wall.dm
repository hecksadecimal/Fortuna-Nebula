/turf/exterior/wall/f13 // Base wall turf for f13
	name = "\improper F13 Wall"

/turf/exterior/wall/f13/denserock
	name = "dense rock"
	material = /decl/material/solid/stone/sandstone

/turf/exterior/wall/f13/denserock/update_strings()
	SetName("dense natural [material.solid_name] wall")
	desc = "A natural cliff face composed of bare [material.solid_name]. It seems incredibly dense."

/turf/exterior/wall/f13/denserock/dismantle_wall()
	return

/turf/exterior/wall/f13/denserock/explosion_act(severity)
	return

/turf/exterior/wall/f13/denserock/set_material(decl/material/newmaterial, decl/material/newrmaterial)
	return

/turf/exterior/wall/f13/denserock/spread_deposit()
	return

/turf/exterior/wall/f13/denserock/attackby(obj/item/W, mob/user, click_params)
	return