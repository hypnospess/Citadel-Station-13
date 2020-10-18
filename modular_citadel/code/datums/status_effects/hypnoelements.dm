
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
**    when the text is displayed. \
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
	var/effectID // The string effect ID of the actual element.
	var/applyBlurb // a string that gets shown when the aid is applied
	var/removeBlurb // a string that gets shown when the aid is removed
	var/moodBlurb // a string that gets shown 

	//var/list/checks //list of all the checktypes and args
	var/checkflags //A bitfield that determines what 
	
	var/viewrange //For the HYPNOTIC_VIEW flag. Determines the view range
	var/viewself //For the HYPNOTIC_VIEW flag. Determines whether or not a mob source can have a hypnotic effect on itself


/datum/element/hypnotic/Attach(datum/target, effect_name, list/bonus_list, apply, remove, mood, check_flags = HYPNOTIC_VIEW, list/check_properties)
	. = ..()
	if(!islist(bonus_list) || !effect_name)
		return ELEMENT_INCOMPATIBLE
	checkflags = check_flags
	bonuses = bonus_list
	effectID = effect_name
	if(apply)
		applyBlurb = apply
	if(remove)
		removeBlurb = remove
	if(mood)
		moodBlurb = mood
	if(checkflags & HYPNOTIC_ABSTRACT)
		RegisterSignal(target, COMSIG_COMPONENT_HYPNO_ABSTRACT, .proc/check_validity)
	if(checkflags & HYPNOTIC_VIEW)
		RegisterSignal(target, COMSIG_COMPONENT_HYPNO_VIEW, .proc/check_validity)
		if(check_properties && check_properties.len)
			viewrange = check_properties[HYPNO_VIEWRANGE] ? check_properties[HYPNO_VIEWRANGE] : null
			viewself = check_properties[HYPNO_VIEWSELF] ? check_properties[HYPNO_VIEWSELF] : null
		if(isnull(viewrange))
			viewrange = HYPNO_VIEWRANGE_DEFAULT
		if(isnull(viewself))
			viewself = TRUE //rule of !!fun!!


/datum/element/hypnotic/Detach(datum/target)
	. = ..()
	if(checkflags & HYPNOTIC_ABSTRACT)
		UnregisterSignal(target, COMSIG_COMPONENT_HYPNO_ABSTRACT)
	if(checkflags & HYPNOTIC_VIEW)
		UnregisterSignal(target, COMSIG_COMPONENT_HYPNO_VIEW)

/*
	VALIDITY CHECKING
	This is what runs when the element is "pinged."
	Behavior is executed depending on what the relevant_flag is, which
	gets passed by the hypnotic effect 

	Ideally, criteria below should be kept as simple as possible.
	Additionally, if it's reasonable to have these validity checks in
	either the object itself or the hypnolistener component, then they
	should be contained there rather than here.
*/

/datum/element/hypnotic/proc/check_validity(atom/A, datum/component/hyplistener/H, relevant_flag)
	if(!istype(H))
		return
	switch(relevant_flag)
		if(HYPNOTIC_VIEW)
			if(H.listener && A && (viewself || H.listener != A) && get_dist(H.listener, A) <= viewrange)
				H.registerAid(effectID, bonuses)
		else
			H.registerAid(effectID, bonuses)
