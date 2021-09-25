//Overrides this proc so common isn't a language assigned to everyone.
/datum/job/equip(var/mob/living/carbon/human/H, var/alt_title, var/datum/mil_branch/branch, var/datum/mil_rank/grade)
	..()
	H.remove_language(/decl/language/human/common)
	H.add_language(/decl/language/human/english)
	H.set_default_language(/decl/language/human/english)
