/obj/item/hypnopendulum
	name = "hypnotic pendulum"
	desc = "A shiny silver ring on a string, used as an effective hypnotic focus."
	icon_state = "hypnopendulum"
	item_state = "hypnopendulum"
	var/hypnotic_power = 60

/obj/item/hypnopendulum/attack(mob/living/carbon/C, mob/living/user)
	if (C != user)
		C.visible_message("<span class='warning'>[user] swings their [src.name] hypnotically in front of [C]'s eyes.</span>")
	else
		C.visible_message("<span class='warning'>[user] swings their [src.name] hypnotically in front of \his own eyes.</span>")
	if (C != user)
		if(do_mob(user, C, 80))
			C.adjustWillPower(hypnotic_power)
			C.visible_message("<span class='notice'>[C]'s eyes follow the pendulum intently.</span>")
		else
			C.visible_message("<span class='warning'>[C] breaks \his focus on the pendulum.</span>")
	else
		if(do_mob(user, C, 80))
			C.adjustWillPower(hypnotic_power * 0.5)
			C.visible_message("<span class='notice'>Your eyes follow the pendulum intently.</span>")
		else
			C.visible_message("<span class='warning'>You break your focus on the pendulum.</span>")
	// animate a sprite to swap to, do a neat little string addition function so that adding more pendulums later is ezpz
	// use similar code to the eyes. should probably deal more WP damage since you don't just start with a pendulum unless you're therapist/bartender
	

/obj/item/hypnopendulum/yoyo
	name = "yo-yo"
	desc = "An orange and grey yo-yo, used as a toy for entertainment... or as a hypnotic focus."
	icon_state = "hypnoyoyo"
	item_state = "hypnoyoyo"
	hypnotic_power = 65

/obj/item/hypnopendulum/watch
	name = "hypnotic watch"
	desc = "A gold-plated pocketwatch, used to keep time... or as a hypnotic focus."
	icon_state = "hypnowatch"
	item_state = "hypnowatch"
	hypnotic_power = 70

	//maybe make this one also have a "check time" verb. just for fun
