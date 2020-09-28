
/*
** THE HYPNO ELEMENT!
** This is a bespoke element that stores hypnosis-effect values and activation criteria.
**
** A quick rundown of how it works:
**	- Upon attaching the element, you feed it an id string, as well as a list of effect values, 
**	  and two lines of text, one to be displayed when the effect is applied to someone, 
** 	  and one to be shown when it is removed.
**
** 	- There's a global list of all of the effect dialogue. This list is added to when a new
** 	  instance of the element is created. This list is what's actually pulled from
**    when the text is displayed.
**
**	- The searcherMob var represents the mob that's "pinging" this element.
**	  In other words, whatever is hypnotized and the effects will be applied to.
** 	  IMPORTANT: this variable is NOT DEFINED until the element is "pinged."
**	  (it is null by default.)
** 	  It should be set to null again at the end of check_validity. (TODO)
**
*/

/datum/element/hypnotic
	element_flags = ELEMENT_DETACH | ELEMENT_BESPOKE
	id_arg_index = 2
	var/list/bonuses // the list of hypnotic bonuses that this element gives out
	var/effectID = "aid-default-effect" // The string effect ID of the actual element.
	var/applyBlurb = "apply placeholder" // a string that gets shown when the aid is applied
	var/removeBlurb = "remove placeholder" // a string that gets shown when the aid is removed

	var/searcherMob // whatever it is that sends out the triggering signal.

	// a 2d list of all add/remove dialogue for aids!
	// this can also be seen as the official effectID registry, though you still have to
	// define the behavior below.
	// In fact, most IDs are added to this list on the fly as they're registered! 
	// I'm using this typed out list as reference for what sends what.

	// NAMING PRACTICES:
	// if an id does something good for the tist, use pos. 
	// if it does something bad for the tist, use neg.
	// if it's mixed, use mix.
	// for "it depends" cases, use aid. (Things starting with aid often have their bonus lists re-defined in the validity code.)
	var/list/global/HYP_DIALOGUE_LIST = list(
		"aid-default-effect" = list("default aid add message!", "default aid remove message!"),
		"pos-faustech-vending" = list("The Faustech-brand vending machine helps remind you of the joys of sinking and obeying.","The Faustech machine is out of earshot, and its jingles no longer affect you."),
		"neg-wanted-poster" = list("Uh oh. It seems like someone's wanted. I should be careful.","You forget about the threat advertised in the wanted poster."),
		"pos-hot-xeno" = list(),
		"aid-synd-recruit" = list(),
		"aid-greytide" = list(),
		"mix-spacecube" = list(),
		"aid-rebel" = list(),
		"neg-redrum" = list(),
		"pos-liz34" = list(),
		"pos-xeno-babes" = list(),
		"pos-cola-post" = list(),
		"pos-faus-p1" = list(),
		"pos-faus-p2" = list(),
		"pos-sal" = list(),
		"pos-lure-p1" = list(),
		"pos-lure-p2" = list(),
		"pos-obey-poster" = list(),
		"pos-question-poster" = list(),
		"pos-greencross" = list(),
		"pos-faus-refill" = list(),
	)

/datum/element/hypnotic/Attach(datum/target,effect_name,list/bonus_list,apply,remove)
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

/datum/element/hypnotic/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, COMSIG_COMPONENT_HYPNO_CHECK)

/*
	VALIDITY CHECKING
	This is what runs when the element is "pinged."
	Behavior is executed depending on what the effectID is,
	and if the criteria for the given effectID is met, then
	the aid is applied to the searcherMob.

	All the criteria checking should be done by simple procs,
	rather than complex code.
	All of these simple "criteria procs" should be defined at the bottom.
	Why? Because readability first, and also, if we use a criteriatype once, 
	we almost certainly will use it again. 
	In the long term, it will make everyone's lives easier <3
*/

/datum/element/hypnotic/proc/check_validity(datum/component/hyplistener/H, atom/A)
	if(!istype(H))
		return
	searcherMob = H.listener
	switch(effectID)
		//THIS IS WHERE CUSTOM BEHAVIOR IS DEFINED.
		//Each specific validity check is in a different if case corresponding to it's effectID.
		//Be sure to call Yes() when you're checking.

		// FAUSTECH VENDOR (et. al)
		if("pos-faustech-vending" || "pos-faus-refill")
			if(Near(4, A))
				Yes(H)

		// POSTERS (TODO)
		// All pos/neg posters have a criteria of:
		// 		Near(6)
		// 		Mob is looking in that general direction.
		// 			Note to Bhijn/158: Make this determination a proc that the element can access.
		// EXCEPT for aid-type posters, and the wanted poster! 
		// Those have specialized requirements.



		//This is the default case, if the specific effectID you've specified has no specified behavior.
		else
			//Mmhm, yeah, just... assume we're supposed to give out the buffs.
			Yes()
			//well, we're done here.

//fuck you i am not writing this every time
//have a method that just calls a method
/datum/element/hypnotic/proc/Yes(datum/component/hyplistener/H)
	if(!istype(H))
		return
	H.registerAid(effectID, bonuses)

/*
	CRITERIA PROCS!
	These are criteria we can check against to make sure that the
	aid should be applied.

	'This thing' always refers to whatever it is that the searchermob is pinging,
	and that this element is attached to.
	'The mob' is always the searcherMob.
*/

//Near: Is this thing within view of the mob?
/datum/element/hypnotic/proc/Near(dist, atom/A)
	/*for(var/atom/I in view(dist, searcherMob))
		if(target == I)
			return TRUE*/
	if(get_dist(searcherMob, A))
		return TRUE
	return FALSE

//LookingAt: Is the mob looking in the general direction of this thing?
// TODO

//Antag: Is the mob an antag (of the specific type, if applicable?)
// TODO

//Wearing: Is the mob wearing this thing?
// TODO

//State: Is this thing in a particular state?
// TODO (also idk how much sense this makes)
