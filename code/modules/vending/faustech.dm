/obj/machinery/vending/faustech
	name = "FausTech"
	desc = "A vending machine for hypnotic fun and science, brought to you by FausTech."
	icon_state = "faustech"
	circuit = /obj/item/circuitboard/machine/faustech
	product_slogans = "Sink, obey, relax.;No thinking, only sinking.;Drop deep."
	vend_reply = "Don't forget to sink and obey!"
	products = list(
				/obj/item/poster/contraband/faustech_1 = 3,
				/obj/item/poster/contraband/faustech_2 = 3,
				/obj/item/poster/contraband/lunarlure_1 = 3,
				/obj/item/poster/contraband/lunarlure_2 = 3,
				/obj/item/reagent_containers/glass/bottle/hexacrocin = 10,
				/obj/item/hypnopendulum = 3,
				/obj/item/clothing/glasses/hypnovisor = 5
				)
	contraband = list(
				/obj/item/clothing/neck/petcollar/locked = 2,
				/obj/item/key/collar = 2
				)
	premium = list(
				/obj/item/poster/contraband/faustech_3 = 1,
				/obj/item/hypnopendulum/yoyo = 1,
				/obj/item/hypnopendulum/watch = 3
				)
	refill_canister = /obj/item/vending_refill/faustech
	default_price = PRICE_BELOW_NORMAL
	extra_price = PRICE_EXPENSIVE
	payment_department = NO_FREEBIES
	cost_multiplier_per_dept = list(ACCOUNT_SCI = 0)
	aid_bonuses = list(5,1,0,0,0,0)

/obj/item/vending_refill/faustech
	machine_name 	= "FausTech"
	icon_state 		= "refill_faustech"

/obj/machinery/vending/faustech/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/hypnotic, "aid-faustech-vending", aid_bonuses, "The Faustech-brand vending machine helps remind you somewhat of the joys of sinking and obeying.", "The Faustech machine is no longer nearby.")
