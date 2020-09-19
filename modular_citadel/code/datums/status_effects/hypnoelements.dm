/*
** This file contains all of the hypno elements.
** The base subtype of hypno element comes first.
** All other subtypes of that, come afterwards.
** Sorry for the needless complexity of this system aaaa
*/

/datum/element/hypnotic
	element_flags = ELEMENT_DETACH | ELEMENT_BESPOKE
	id_arg_index = 2
	var/list/bonuses //the list of hypnotic bonuses that this element gives out
	var/effectID //The string effect ID of the actual element.  

	var/searcherMob //whatever it is that sends out the triggering signal.

datum/element/hypnotic/Attach(datum/target,effect_name,list/bonus_list)
	. = ..()
	if(!islist(bonus_list) || !effect_name)
		return ELEMENT_INCOMPATIBLE
	bonuses = bonus_list
	effectID = effect_name
	RegisterSignal(target,COMSIG_COMPONENT_HYPNO_CHECK,.proc/check_validity)

datum/element/hypnotic/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, COMSIG_COMPONENT_HYPNO_CHECK)

datum/element/hypnotic/proc/check_validity(datum/component/hyplistener/H)
	searcherMob = H.listener
	switch(effectID)
		//THIS IS WHERE CUSTOM BEHAVIOR IS DEFINED.
		//Each specific validity check is in a different if case corresponding to it's effectID.
		//Be sure to call H.registerAid(effectID, bonuses) when you're done.

		//This is the default case, if the specific effectID you've specified has no specified behavior.
		else
			//Mmhm, yeah, just... assume we're supposed to give out the buffs.
			H.registerAid(effectID, bonuses)
			//well, we're done here.

			

