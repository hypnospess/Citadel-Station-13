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
	var/effectID = "trance-default-effect"//The string effect ID of the actual element.  
	var/applyBlurb = "apply placeholder for [effectID]"//a string that gets shown when the aid is applied
	var/removeBlurb = "remove placeholder for [effectID]" //a string that gets shown when the aid is removed

	var/searcherMob //whatever it is that sends out the triggering signal.

datum/element/hypnotic/Attach(datum/target,effect_name,list/bonus_list,apply,remove)
	. = ..()
	if(!islist(bonus_list) || !effect_name)
		return ELEMENT_INCOMPATIBLE
	bonuses = bonus_list
	effectID = effect_name
	if(apply)
		applyBlurb = apply
	if(remove)
		removeBlurb = remove
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
		if("aid-faustech-vending")
			if(Near(4))
				Yes()
		//This is the default case, if the specific effectID you've specified has no specified behavior.
		else
			//Mmhm, yeah, just... assume we're supposed to give out the buffs.
			Yes()
			//well, we're done here.

//fuck you i am not writing this every time
//have a method that just calls a method
datum/element/hypnotic/proc/Yes()
	H.registerAid(effectID, bonuses)

//check if near
datum/element/hypnotic/proc/Near(var/dist)
	for(var/datum/I in searcherMob.view(dist))
		if(target == I)
			return TRUE
	return FALSE
