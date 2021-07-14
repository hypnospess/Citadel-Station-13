/obj/item/clothing/glasses/hypnovisor
	name = "hypnotic visor"
	desc = "A FausTech hypnotic visor, designed to keep a subject deep on the go."
	icon_state = "hypnovisor"
	item_state = "hypnovisor"
	var/visor_toggled = FALSE

// /obj/item/clothing/glasses/hypnovisor/lurevisor
// 	name = "hypnotic visor"
// 	desc = "A FausTech hypnotic visor, specially programmed for Lunar Lure staff training."
// 	icon_state = "lurevisor"
// 	item_state = "lurevisor"
// 	visor_toggled = FALSE


/obj/item/clothing/glasses/hypnovisor/AltClick(mob/user)
	. = ..()
	if (!user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	togglevisor(user)
	return TRUE

/obj/item/clothing/glasses/hypnovisor/ui_action_click(mob/user, actiontype)
	togglevisor(user)

/obj/item/clothing/glasses/hypnovisor/proc/togglevisor(mob/living/user)
	visor_toggled = !visor_toggled
	if (!visor_toggled)
		src.icon_state = initial(icon_state)
		to_chat(user, "<span class ='notice'>You switch the visor off.</span>")
		update_icon()
		//no hypno
	else
		icon_state += "_on"
		to_chat(user, "<span class ='notice'>You switch the visor on.</span>")
		update_icon()
		//yes hypno
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.head_update(src, forced = 1)

// /obj/item/item/clothing/glasses/hypnovisor/equipped(mob/user, slot)
// 	..()
// 	if (slot == SLOT_GLASSES && visor_toggled)
// 		user.adjustWillPower(0.5)

//get this to work when you're less tired
