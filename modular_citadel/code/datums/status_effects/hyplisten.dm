//this is the listener portion of the hypno effect.
//not sure how this will work, but we shall see.

/*
	IMPORTANT: DIFFERENCE BETWEEN COMPULSIONS AND COMMANDS
	Commands are a one and done. You say it once, it has an effect. 
	That effect may be a simple action, 
	or it might be an aesthetic or vocal effect that can be cancelled.

	Compulsions are an extended effect! Think of them more like a task that requires involvement.
	They can be resist-mashed out of.

	Basically, if it's something that can be done on the spot, it's a command.
	If it's something that requires movement or significant involvement,
	or ACTIVE ROLEPLAY on the part of the victim, it's a compulsion.

	OKAY CONCEPT: AID IS GOTTEN THROUGH A SIGNAL!!
	when someone is targeting something with an aid (or it just... is on them)
	it tells the mob to send a TRANCE_AID_ADD signal
	with a little indicator of what the aid is
	and when it's removed it makes the mob send a TRANCE_AID_REMOVE signal! 
	(again, indicating what the aid is is.)
	the signals will also send the scale modifier amount.
*/


/datum/component/hyplistener
	var/outputstate = 0 //this is what actually determines what should be happening. It will be returned.
	var/laststate = 0 //the last unique, nonzero state. Used to make sure that a state is held onto until the next effect update.
	var/mob/living/carbon/listener //this is the mob that this is attached to.
	var/datum/status_effect/hypno/effect //this is the status effect that this is attached to

	var/list/aidlist //the list of aids affecting the trance!

/datum/component/hyplistener/Initialize(linked_effect)	//this is probably not gonna be the final init i am just putting it here for now
	if(!parent||!linked_effect)
		return COMPONENT_INCOMPATIBLE
	effect = linked_effect
	if(istype(effect))
		listener = effect.owner
	RegisterSignal(parent, COMSIG_MOVABLE_HEAR, .proc/parse)

//at some point i need to unregister the signal, i think?? like when it gets delet.
/datum/component/hyplistener/Destroy()
	UnregisterSignal(parent, COMSIG_MOVABLE_HEAR)
	. = ..() //haha hope this works :D

/datum/component/hyplistener/proc/parse(datum/source, list/hearing_args)
	if(!istype(effect) || !istype(listener))
		return

	var/unproc = hearing_args[HEARING_RAW_MESSAGE]
	var/msg = lowertext(unproc)
	for(var/datum/trance_effect/T in SShypno.trance_effects)
		if(effect.scale >= T.req_scale)
			if(findtext(msg, regex(T.wordlist)))
				outputstate = T.trigger(listener, effect) //`outputstate =` is just a hack for compatibility with the currently existing code. to be removed when trance effects are moved to trance_effect.trigger()
				break

//this one just does the outputstate updating.
/datum/component/hyplistener/proc/out(var/state)
	var/isNonzero = FALSE
	var/isNew = FALSE
	if(state != 0)
		isNonzero = TRUE
	if(state != laststate)
		isNew = TRUE
	if((isNonzero && isNew)||(laststate == 0))
		outputstate = state
		return

/datum/component/hyplistener/proc/getState()
	if(outputstate == 0)
		return laststate
	return outputstate

/datum/component/hyplistener/proc/ping_nearby(view_distance)
	aidlist = list()
	//yadda yadda get things in view of the mob
	for(var/atom/A in view(view_distance, listener))
		//iterate through
		//send signal
		SEND_SIGNAL(A, COMSIG_COMPONENT_HYPNO_CHECK, src, A)

/datum/component/hyplistener/proc/registerAid(aidID, list/bonuses)
	aidlist[aidID] = bonuses

/datum/component/hyplistener/proc/sum_bonuses()
	var/list/bonuses_summed = list(0,0,0,0,0,0)
	for(var/list/B in aidlist)
		for(var/i = 1, i <= 6, i++)
			bonuses_summed[i] = B[i]
	return bonuses_summed

//some hyplistener stuff to do blurbs, bleh!
