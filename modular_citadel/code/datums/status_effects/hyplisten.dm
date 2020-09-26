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
	
	
	//earlystage commands (mostly aesthetic, with a few exceptions)
	var/static/regex/smile_words = regex("smile|grin|happy|feeling good|bliss") //like in the velvet chords, we use regexes
	var/static/regex/laugh_words = regex("laugh|giggle|chuckle|guffaw|cackle|funny|silly|goofy")
	var/static/regex/drool_words = regex("drool|drip|salivate|saliva|dribble")
	var/static/regex/lay_words = regex("lie down|lay down|recline|on the floor|on the ground|kneel|on your knees|on all fours")
	var/static/regex/relax_words = regex("relax|loose|limp|sink|slip|deep|drift")
	var/static/regex/atease_words = regex("at ease|stop|back to normal")
	var/static/regex/scale_words = regex("how deep|how hypnotized|scale")
	//more eventually

	//earlystage compulsions (simple compulsions to act, very easy to comprehend)
	var/static/regex/flee_words = regex("go away|fuck off|piss off|flee|leave me alone")
	var/static/regex/walk_words = regex("walk|go|proceed|shuffle")
	var/static/regex/follow_words = regex("follow me|come with me|let's go")
	//more eventually

	//deeper compulsions
	var/static/regex/phobia_words = regex("is scary|is terrifying|horrifies you|is your greatest fear")
	var/static/regex/philia_words = regex("you love|you need|obessed with|craving|desiring|needing")
	var/static/regex/goal_words = regex("new objective|obey this command|unable to resist|compelled|word from hq|new goal") //shh stolen from velvet chords
	var/static/regex/restriction_words = regex("don't|stop|halt|cease|never")
	//maybe more?

	//deeper commands
	//none yet
	var/static/regex/piss_words = regex("piss|take a leak|flood|pee|urinate")

	//deepest compulsions
	//none yet
	var/static/regex/gather_words = regex("retrieve|fetch|go get|pick up|gather")

	//deepest commands
	//none yet

	//constructor goes here
	
/datum/component/hyplistener/Initialize(linked_effect)	//this is probably not gonna be the final init i am just putting it here for now
	if(!parent||!linked_effect)
		return COMPONENT_INCOMPATIBLE
	effect = linked_effect
	RegisterSignal(parent, COMSIG_MOVABLE_HEAR, .proc/parse)

//at some point i need to unregister the signal, i think?? like when it gets delet.
/datum/component/hyplistener/Destroy()
	UnregisterSignal(parent, COMSIG_MOVABLE_HEAR)
	. = ..() //haha hope this works :D

/datum/component/hyplistener/proc/parse(datum/source, list/hearing_args)
	//this proc does all of the parsing!
	//these should eventually be re-ordered in terms of reverse priority.
	//eg: things that override other things come later.	 
	var/unproc = hearing_args[HEARING_RAW_MESSAGE]
	var/msg = lowertext(unproc)
	//simple commands
	//Smile (state 1)
	if(findtext(msg, smile_words))
		outputstate = 1
	//laugh (state 2)
	if(findtext(msg, laugh_words))
		outputstate = 2
	//drool (state 3)
	if(findtext(msg, drool_words))
		outputstate = 3
	//lay down (state 4)
	if(findtext(msg, lay_words))
		outputstate = 4
	//relax (state 5)
	if(findtext(msg, relax_words))
		outputstate = 5
	//at ease (return to normal desc) (state 6)
	if(findtext(msg,atease_words))
		outputstate = 6
	//scale (state 7)
	if(findtext(msg,scale_words))
		outputstate = 7
	
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
