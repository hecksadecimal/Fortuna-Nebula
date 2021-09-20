//Contains Oasis
/decl/department/oasis
	name = "Oasis"
	display_priority = -1
	display_color = "#6d2504"

/datum/job/oasis
	title = "Oasis"
	total_positions = 0
	spawn_positions = 0
	supervisors = "The Mayor"
	access = list()
	minimal_access = list(
		access_oasis_general
	)
	outfit_type = /decl/hierarchy/outfit/job/oasis
	department_types = list(/decl/department/oasis)

/datum/job/oasis/mayor
	title = "Mayor"
	total_positions = 1
	spawn_positions = 1
	supervisors = "The townspeople"
	access = list(
		access_oasis_general,
		access_oasis_shopkeep,
		access_oasis_barkeep,
		access_oasis_deputy,
		access_oasis_mayor
	)
	minimal_access = list(
		access_oasis_general,
		access_oasis_shopkeep,
		access_oasis_barkeep,
		access_oasis_deputy,
		access_oasis_mayor
	)
	outfit_type = /decl/hierarchy/outfit/job/mayor

/datum/job/oasis/sheriff
	title = "Sheriff"
	total_positions = 4
	spawn_positions = 4
	supervisors = "The Sheriff"
	access = list(
		access_oasis_general,
		access_oasis_barkeep,
		access_oasis_deputy
	)
	minimal_access = list(
		access_oasis_general,
		access_oasis_barkeep,
		access_oasis_deputy
	)
	outfit_type = /decl/hierarchy/outfit/job/sheriff

/datum/job/oasis/deputy
	title = "Deputy"
	total_positions = 4
	spawn_positions = 4
	supervisors = "The Sheriff"
	access = list(
		access_oasis_general,
		access_oasis_deputy
	)
	minimal_access = list(
		access_oasis_general,
		access_oasis_deputy
	)
	outfit_type = /decl/hierarchy/outfit/job/deputy

/datum/job/oasis/shopkeep
	title = "Shopkeeper"
	total_positions = 2
	spawn_positions = 2
	supervisors = "The Mayor"
	access = list(
		access_oasis_shopkeep
	)
	minimal_access = list(
		access_oasis_shopkeep
	)
	outfit_type = /decl/hierarchy/outfit/job/shopkeep

/datum/job/oasis/detective
	title = "Detective"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Paying Clients"
	outfit_type = /decl/hierarchy/outfit/job/detective

/datum/job/oasis/preacher
	title = "Preacher"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Whatever God you beleive in... And the town."
	is_holy = TRUE
	alt_titles = list("Cleric", "Deacon", "Imam", "Pujari", "Atom's Devout")
	outfit_type = /decl/hierarchy/outfit/job/preacher

/datum/job/oasis/barkeep
	title = "Barkeep"
	total_positions = 2
	spawn_positions = 2
	supervisors = "The Mayor"
	access = list(
		access_oasis_barkeep
	)
	minimal_access = list(
		access_oasis_barkeep
	)
	alt_titles = list("Innkeeper")
	outfit_type = /decl/hierarchy/outfit/job/barkeep

/datum/job/oasis/citizen
	title = "Citizen"
	total_positions = 12
	spawn_positions = 12
	supervisors = "Oasis Police and Government"
	alt_titles = list("Farmer", "Prospector", "Performer")
	outfit_type = /decl/hierarchy/outfit/job/citizen

