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
	var/mob/living/carbon/listener //this is the mob that this is attached to.
	var/datum/status_effect/hypno/effect //this is the status effect that this is attached to

	var/list/aidlist //the list of aids affecting the trance!

	var/list/abstract_aids //Aid components that don't exactly have a physical presence 

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
				if(T.trigger(listener, effect))
					break

/datum/component/hyplistener/proc/ping_nearby(view_distance)
	aidlist = list()

	for(var/atom/A in abstract_aids)
		SEND_SIGNAL(A, COMSIG_COMPONENT_HYPNO_ABSTRACT, src, HYPNOTIC_ABSTRACT)

	for(var/atom/A in view(view_distance, listener))
		SEND_SIGNAL(A, COMSIG_COMPONENT_HYPNO_VIEW, src, HYPNOTIC_VIEW)

/datum/component/hyplistener/proc/registerAid(aidID, list/bonuses)
	aidlist[aidID] = bonuses

/datum/component/hyplistener/proc/sum_bonuses()
	var/list/bonuses_summed = list(0,0,0,0,0,0)
	for(var/hypnoaid in aidlist)
		var/list/L = aidlist[hypnoaid]
		for(var/i in 1 to 6)
			bonuses_summed[i] += L[i]
	return bonuses_summed

/datum/component/hyplistener/proc/registerAbstractAid(atom/A)
	if(!A)
		return
	LAZYINITLIST(abstract_aids)
	abstract_aids |= A

/datum/component/hyplistener/proc/unregisterAbstractAid(atom/A)
	if(!A)
		return
	LAZYINITLIST(abstract_aids)
	abstract_aids -= A

//some hyplistener stuff to do blurbs, bleh!
