SUBSYSTEM_DEF(hypno)
	name = "Hypno"
	flags = SS_NO_FIRE

	var/list/trance_effects = list()

/datum/controller/subsystem/hypno/Initialize(start_timeofday)
	for(var/zonk in subtypesof(/datum/trance_effect))
		var/datum/trance_effect/T = new zonk
		trance_effects |= T
	return ..()
