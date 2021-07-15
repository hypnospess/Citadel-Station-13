//willpower is a backend system designed to implement hypnosis effects in a simple and practical way
//humans (or equivalent, ofc) have willpower in the form of WP, it's basically like another body part

//todo
//define weak and strongwilled traits [x]
//write the thing that applies zonk damage [x]
//institute passive willpower regeneration [x] 
//zonk feedback
//moodlets/examine text for zonked players
//assign willpower regeneration buffs to things that might have that
//assign zonk damage to thinks that might have that
//make resisting do something (?)

//this is for my reference

//Updates the mob's health from bodyparts and mob damage variables
// /mob/living/carbon/updatehealth()
// 	if(status_flags & GODMODE)
// 		return
// 	var/total_burn	= 0
// 	var/total_brute	= 0
// 	var/total_stamina = 0
// 	for(var/X in bodyparts)	//hardcoded to streamline things a bit
// 		var/obj/item/bodypart/BP = X
// 		total_brute	+= (BP.brute_dam * BP.body_damage_coeff)
// 		total_burn	+= (BP.burn_dam * BP.body_damage_coeff)
// 		total_stamina += (BP.stamina_dam * BP.stam_damage_coeff)
// 	health = round(maxHealth - getOxyLoss() - getToxLoss() - getCloneLoss() - total_burn - total_brute, DAMAGE_PRECISION)
// 	staminaloss = round(total_stamina, DAMAGE_PRECISION)
// 	update_stat()
// 	if(((maxHealth - total_burn) < HEALTH_THRESHOLD_DEAD*2) && stat == DEAD )
// 		become_husk("burn")
// 	med_hud_set_health()
// 	if(stat == SOFT_CRIT)
// 		add_movespeed_modifier(/datum/movespeed_modifier/carbon_softcrit)
// 	else
// 		remove_movespeed_modifier(/datum/movespeed_modifier/carbon_softcrit)

//define each level of zonkedness:
// lucid, fuzzy, dazed, mindless, mindbroken
#define LUCID  		0
#define FUZZY 		1
#define DAZED  		2
#define MINDLESS    3
#define MINDBROKEN  4

mob/var/maxWillPower = 625 //subject to change throughout development. also may be this should only apply to humans?
mob/var/WillPower = 625
mob/var/lucidity = LUCID
mob/var/WillLoss = 0 //only change this with procs, as with any other damage type

/mob/living/carbon/proc/updateWillPower()
	if(status_flags & GODMODE)
		return
	WillPower = round(maxWillPower - WillLoss)
	update_lucidity()

/mob/living/carbon/proc/update_lucidity()
	if(status_flags & GODMODE)
		return
	if(stat != DEAD)
		if (WillPower > 585 && lucidity != LUCID)
			lucidity = LUCID
			//to_chat(src, "<span class='notice'>You feel much more awake.</span>")
			visible_message("<span class='userlove'>[src] seems to awaken.</span>", "<span class='userlove'>You feel much more awake.</span>", null, 3) //just gonna test this here
		if (WillPower <= 585 && WillPower > 525 && lucidity != FUZZY)
			lucidity = FUZZY
			visible_message("<span class='userlove'>[src] looks relaxed.</span>", "<span class='userlove'>Your head feels fuzzy.</span>", null, 3)
			if (HAS_TRAIT(src, TRAIT_MINDBROKEN))
				REMOVE_TRAIT(src, TRAIT_MINDBROKEN, ZONK_TRAIT)
				to_chat(src, "<span class='warning'>You feel more like yourself again, as your mind recovers.</span>")
		if (WillPower <= 525 && WillPower > 375 && lucidity != DAZED)
			lucidity = DAZED
			visible_message("<span class='userlove'>[src] looks really out of it.</span>", "<span class='userlove'>You fall into a pleasant daze.</span>", null, 3)
		if (WillPower <= 375 && WillPower > 0 && lucidity != MINDLESS)
			lucidity = MINDLESS
			visible_message("<span class='userlove'>[src]'s eyes glass over, and they seem very deep in a trance.</span>", "<span class='userlove'>Your thoughts fade away, leaving your mind completely empty.</span>", null, 3)
		if (WillPower <= 0 && lucidity != MINDBROKEN)
			lucidity = MINDBROKEN
			visible_message("<span class='userlove'>[src] looks completely fargone.</span>", "<span class='warning'>Something in your mind snaps.</span>", null, 3)
			if (!HAS_TRAIT(src, TRAIT_MINDBROKEN)) //we make mindbroken a trait so that it can persist for longer than just having 0 WP
				ADD_TRAIT(src, TRAIT_MINDBROKEN, ZONK_TRAIT)

mob/living/carbon/proc/adjustWillPower(amount)
	var/damage_multiplier = 1
	if (amount > 0)
		if(HAS_TRAIT(src, TRAIT_WEAKWILLED)) //take extra willpower damage
			damage_multiplier = damage_multiplier * 1.2
		if(HAS_TRAIT(src, TRAIT_STRONGWILLED)) //take less willpower damage
			damage_multiplier = damage_multiplier * 0.8
		if(HAS_TRAIT(src, TRAIT_MINDSHIELD)) //take less willpower damage
			damage_multiplier = damage_multiplier * 0.5
		WillLoss += amount * damage_multiplier
	else WillLoss += amount
	if (WillLoss < 0)
		WillLoss = 0
	if (WillLoss > maxWillPower)
		WillLoss = maxWillPower
	updateWillPower()
	
//maybe consider adding flavor  text for damage levels. like if the damage is high enough, display text varying from "this is relaxing" to "you feel your thoughts evaporating"

//general-purpose handler that's called every tick (if you're alive).
//handles passive WP regen, mostly. might do other stuff later
mob/living/carbon/proc/handle_willpower()
	var/CurrentWillPowerRegen = -1 //1 WP per second!
	if (HAS_TRAIT(src, TRAIT_MINDSHIELD))
		CurrentWillPowerRegen = -2 //2 WP per second. combined with the negative damage multiplier, makes mindshielded people pretty resilient to hypnosis
	if (HAS_TRAIT(src, TRAIT_MINDBROKEN))
		CurrentWillPowerRegen = 2 //mindbroken people, mindshielded or not, passively fall deeper into trance
	adjustWillPower(CurrentWillPowerRegen)

//code example of regeneration
	// if(drunkenness)
	// 	drunkenness = max(drunkenness - (drunkenness * 0.04), 0)
	// 	if(drunkenness >= 6)
	// 		SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "drunk", /datum/mood_event/drunk)
	// 		jitteriness = max(jitteriness - 3, 0)
	// 		if(HAS_TRAIT(src, TRAIT_DRUNK_HEALING))
	// 			adjustBruteLoss(-0.12, FALSE)
	// 			adjustFireLoss(-0.06, FALSE)
			