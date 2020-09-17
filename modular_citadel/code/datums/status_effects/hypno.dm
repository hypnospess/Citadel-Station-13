/datum/status_effect/hypno 
	/*
		Actually, we do aids through signals that hyplistener picks up, we'll figure that out later.
	*/
	var/id = "hypno"
	var/alert_type = null
	var/on_remove_on_mob_delete = TRUE
	var/examine_text = "[SUBJECTPRONOUN] looks a bit woozy."
	var/blocks_combatmode = TRUE //this may change if it's stupid
	var/status_type = STATUS_EFFECT_UNIQUE
	tick_interval = 2
	
	var/scale = 10 //deepness level from 100 (fully entranced) to 0 (fully awake)
	var/resist_amt = 0 //amount of resistance (increased by pressing resist.)
	var/resist_cap = 15 //max amount of resistance points
	var/deepener_mult = 1 //the multiplier for deepening effects
	var/delta_scale = 0 //amount by which to change the scale on the next tick
	var/relax_amt = 0 //amount of relaxation points
	var/relax_cap = 5 //max amount of relaxation points 
	var/scale_cap = 50 //highest scale without aids
	var/default_scale_cap = 50 //the natural resting place of the scale cap. (for calculation purposes)

	var/list/aids //list of trance aids. different aids have different IDs.

	var/ticks_since_last_resist = 0 //how long ago the last resist was
	var/ticks_since_last_relax = 0 //how long ago was the last relaxation
	var/delta_resist = FALSE //has sub already resisted this tick?

	/*
		TRANCE AIDS:
		basically, things that help u go into trance, outside of the effect.
		Different aids add to your scale cap by different amounts.
		Aids are differentiated by their position in the list. Don't worry about it for now.
	*/

	var/last_state = 0 //the last unique state returned by the HL
	var/current_state = 0 //the current state as given by the HL

	var/datum/mob/living/carbon/sub //the actual subject!
	//friendly reminder to self: owner is the person who has the effect.
	var/datum/component/hyplistener/HyL //the hyplistener

	/*
		hyplistener will be added on mob add, and delet when on mob remove
		something like that, i guess! now time to figure out how do
	*/

	//on_apply setup
	/datum/status_effect/hypno/proc/on_apply() 
		. = ..()
		if(!(istype(owner, sub))) //god i hope this works! :D
			return FALSE
			//output something saying "whoopsie, not living carbon"
		sub = owner
		check_aids()
		HyL = new hyplistener(sub, src)
		if (!HyL)
			return FALSE
		//hope i put this in the right place aahahah,,
		RegisterSignal(owner, COMSIG_LIVING_RESIST, .proc/do_resistance)
		return
		

	//before_remove setup?? idk

	//on_remove setup
	/datum/status_effect/hypno/proc/on_remove()
		. = ..()
		//uhh, get rid of the component.
		HyL.Destroy() //is this how you do it???
		UnregisterSignal(owner, COMSIG_LIVING_RESIST)

	//tick!!
	/datum/status_effect/hypno/proc/tick()
		//do effect stuff

		//do math
		change_scale()
		//remove if the scale is 0 or less

		//end of tick cleanup!
		if(!do_relaxation(FALSE))
			ticks_since_last_relax += 1
		if(!do_resistance(FALSE))
			ticks_since_last_resist += 1
		delta_resist = FALSE

	//here be other procs
	/datum/status_effect/hypno/proc/check_aids()
		//haha do nothing for now lmaooooo
		//it will add to the list of trance aids present in the environment
		return
	/datum/status_effect/hypno/proc/aid_setup()
		//haha do nothing for now
		//will do aid setup
		//sum aid scale buffs
		//add to default max to make scale cap
		return

	//does math to determine the new scale
	/datum/status_effect/hypno/proc/change_scale()
		delta_scale = (relax_amt*deepener_mult) - resist_amt
		scale += delta_scale
		return scale

	//make sure resistance doesn't go above cap. also check if we should be adding. 
	//also reduce resistance if there's been a while since last resist
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
		if(ticks_since_last_resist >= 25) //if it's been 5 seconds since last resist
			resist_amt -= 1
			ticks_since_last_resist -= 10 //2 sec til next delet
		return resisted
	
	//make sure relaxation doesn't go above the cap.
	//also increase relaxation if need be.
	//also, decrease relaxation if it's been a while since last relaxation.
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
		if(ticks_since_last_relax >= 300)	//one minute without relax
			relax_amt -= 1
			ticks_since_last_relax -= 75 //15 sec until next delet
		return relaxed
