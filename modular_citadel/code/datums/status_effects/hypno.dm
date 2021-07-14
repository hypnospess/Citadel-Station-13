/datum/status_effect/hypno 
	/*
		Actually, we do aids through signals that hyplistener picks up, we'll figure that out later.
	*/
	id = "hypno"
	alert_type = null
	on_remove_on_mob_delete = TRUE
	examine_text = "They look a bit woozy."
	blocks_combatmode = TRUE //this may change if it's stupid
	status_type = STATUS_EFFECT_UNIQUE
	tick_interval = 2

	var/static/default_scale_cap = 50 //the natural resting place of the scale cap. (for calculation purposes)
	var/static/default_relax_cap = 5
	var/static/default_resist_cap = 15

	var/scale = 10 //deepness level from 100 (fully entranced) to 0 (fully awake)
	var/resist_amt = 0 //amount of resistance (increased by pressing resist.)
	var/resist_cap = 15 //max amount of resistance points
	var/deepener_mult = 1 //the multiplier for deepening effects
	var/delta_scale = 0 //amount by which to change the scale on the next tick
	var/relax_amt = 0 //amount of relaxation points
	var/relax_cap = 5 //max amount of relaxation points 
	var/scale_cap = 50 //highest scale without aids

	var/ticks_since_last_resist = 0 //how long ago the last resist was
	var/ticks_since_last_relax = 0 //how long ago was the last relaxation
	var/delta_resist = FALSE //has sub already resisted this tick?

	var/firstSetup = TRUE //is this the first run through the tick method?
	var/isSmiling = FALSE
	var/laughTimer = 0 //amount of ticks until laughter is done

	var/last_state = 0 //the last unique state returned by the HL
	var/current_state = 0 //the current state as given by the HL

	//friendly reminder to self: owner is the person who has the effect.
	var/mob/living/carbon/sub //the subject!
	var/datum/component/hyplistener/HyL //the hyplistener

	var/list/bonuses = list(0,0,0,0,0,0)//a list containing all the stat buffs and debuffs granted by nearby trance aids.

	/*
		TRANCE AIDS:
		basically, things that help u go into trance, outside of the effect.
		Different aids add to your scale cap by different amounts.
		Aids are differentiated by their position in the list. Don't worry about it for now.
	*/

	//on_apply setup
/datum/status_effect/hypno/on_apply()
	. = ..()
	if(!iscarbon(owner)) //god i hope this works! :D
		return FALSE
		//output something saying "whoopsie, not living carbon"
	sub = owner
	check_aids()
	//hope i put this in the right place aahahah,,
	RegisterSignal(owner, COMSIG_LIVING_RESIST, .proc/do_resistance)
	return TRUE
		

	//before_remove setup?? idk
/datum/status_effect/hypno/before_remove()
	qdel(HyL) //is this how you do it???
	return TRUE

	//on_remove setup
/datum/status_effect/hypno/on_remove()
	. = ..()
	//uhh, get rid of the component.
	UnregisterSignal(owner, COMSIG_LIVING_RESIST)

	//////////////
	//  tick!!  //
	//////////////

/datum/status_effect/hypno/tick()
	if (firstSetup)
		HyL = new(list(sub, src))
		firstSetup = FALSE
	//check state and perform accordingly
	handle_effect(HyL.getState())

	//do laughter stuff
	if(laughTimer)
		var/laughprob = rand(1,10)
		if(laughprob == 10)
			owner.say(pick("Hahaha!","Hee Hee!","Pffft~","Hehehe!","Ahahah!"))
		laughTimer -= 1
		if(!laughTimer)
			to_chat(owner,"<span class='notice'>You stop laughing!</span>")

	//do aid stuff
	aid_setup(6)
	check_aids()
	//do math
	change_scale()

	//end of tick cleanup!
	if(!do_relaxation(FALSE))
		ticks_since_last_relax += 1
	if(!do_resistance(FALSE))
		ticks_since_last_resist += 1
	delta_resist = FALSE

	//remove if scale is 0 or less
	if(scale <= 0)
		owner.remove_status_effect(src)

	///////////////////////
	//here be other procs//
	///////////////////////

//apply the effects of bonuses from aids in the environment.
/datum/status_effect/hypno/proc/check_aids()
	/* the order of bonus effects in the list is as follows.
	** 1: scale cap change. can't result in a max scale above 100.
	** 2: relax cap change. Increases/decreases amount of relaxation points one can gain.
	** 3: resist cap change. Increases/decreases amount of resistance points one can gain.
	** 4: raw scale bonus. If positive, makes sure scale is always at least that large. If negative, subtracts from scale.
	**	  -- Note: negative scales as a result of this are functionally 0.
	** 5: raw relaxation bonus. either adds or subtracts points of relaxation.
	**    -- Note: negative relaxation values remain negative.
	** 6: raw resistance bonus. either adds or subtracts points of resistance.
	**    -- Note: negative resistance values remain negative. */

	scale_cap = default_scale_cap + bonuses[1]
	relax_cap = default_relax_cap + bonuses[2]
	resist_cap = default_resist_cap + bonuses[3]
	if(scale_cap > 100)
		scale_cap = 100
	//for now, i don't wanna make 0 value point caps a thing.
	//maybe later. 
	//negative values are an absolute no go!
	if(relax_cap < 1)
		relax_cap = 1
	if(resist_cap < 1)
		resist_cap = 1

	//if your scale is less than your scale bonus, fix it.
	if(scale <= bonuses[4])
		scale = bonuses[4]
	//if your bonus is negative, subtract. If scale is negative, it's 0.
	if(bonuses[4] < 0)
		scale -= bonuses[4]
		if(scale < 0)
			scale = 0
	relax_amt += bonuses[5]
	resist_amt += bonuses[6]

	//make sure nothing is surpassing their caps.
	if(scale > scale_cap)
		scale = scale_cap
	if(relax_amt > relax_cap)
		relax_amt = relax_cap
	if(resist_amt > resist_cap)
		resist_amt = resist_cap
	return

//get and setup the list of aids in the environment.
/datum/status_effect/hypno/proc/aid_setup(var/viewdistance)
	HyL.ping_nearby(viewdistance)
	bonuses = HyL.sum_bonuses()
	

//does math to determine the new scale
/datum/status_effect/hypno/proc/change_scale()
	//delta_scale = (relax_amt*deepener_mult) - resist_amt
	delta_scale = ((relax_amt*deepener_mult)/(ticks_since_last_relax + 1)) - (resist_amt/ticks_since_last_resist)
	scale += delta_scale
	if(scale > scale_cap)
		scale = scale_cap
	return scale

//updates resistance
/datum/status_effect/hypno/proc/do_resistance(var/uptick = TRUE)
	var/resisted = FALSE
	if(uptick)
		if(!delta_resist) //if we havent resisted this tick
			resist_amt += 1
			delta_resist = TRUE //we have now resisted
			resisted = TRUE
	if (resist_amt > resist_cap) //don't go over the cap
		resist_amt = resist_cap
	if(resisted || delta_resist) //if we've resisted this tick:
		ticks_since_last_resist = 0
	if(ticks_since_last_resist >= 25 && resist_amt > 0) //if it's been 5 seconds since last resist
		resist_amt -= 1
		ticks_since_last_resist -= 10 //2 sec til next delet
	return resisted
	
//updates relaxation.
/datum/status_effect/hypno/proc/do_relaxation(var/uptick = FALSE)
	var/relaxed = FALSE
	//if it's supposed to increase relaxation:
	if(uptick)
		relax_amt += 1
		relaxed = TRUE
	//if relaxation is too high:
	if(relax_amt > relax_cap)
		relax_amt = relax_cap
	//if this method increased relaxation:
	if(relaxed)
		ticks_since_last_relax = 0
	//if it's been 15 ticks since last relaxation:
	if(ticks_since_last_relax >= 300 && relax_amt > 0)	//one minute without relax
		relax_amt -= 1
		ticks_since_last_relax -= 75 //15 sec until next delet
	return relaxed
//handles the listener input
/datum/status_effect/hypno/proc/handle_effect(var/statusCode)
	if(!statusCode)
		return	//default case of 0, nothing happens.
	if(compare_state(statusCode))
		switch(statusCode)
			if(1) //smile! :D
				to_chat(owner, "<span class='notice'>You smile widely! You're the happiest you've felt in a long time.")
				examine_text = "They're smiling widely. They're probably just happy to be here."
				//do a visual message to everyone nearby!
				if(!isSmiling)
					owner.visible_message("[owner.real_name] starts to grin happily! It looks like they're having a really good time.", "You smile as widely as you can! This is the happiest you've been in a long time.")
					isSmiling = TRUE
			if(2) //laugh! :D
				if(laughTimer == 0)
					to_chat(owner, "<span class='notice'>Everything seems really funny all of the sudden!</span>")
					owner.audible_message("[owner.real_name] begins to giggle!", "Everything seems really funny all of the sudden!")
					laughTimer = 150
			if(5) //skipping straight to relax for now
				do_relaxation(TRUE)
				to_chat(owner, "You relax a little bit.")
			if(7) //again, skipping to scale for now
				owner.say("[scale].")
//compares a given state to the last state recieved
/datum/status_effect/hypno/proc/compare_state(var/inState)
	//if the new state is the same as the old state, return false
	//if the new state is different from the old state, return true. then make the new state the old state.
	if(inState == last_state)
		return FALSE
	if(inState != last_state)
		last_state = inState
		return TRUE
