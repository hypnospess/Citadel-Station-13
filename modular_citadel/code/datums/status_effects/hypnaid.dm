/*
** This datum deals with hypnotic aids.
** It's basically just a package for data, that makes everyone's lives easier.
** (I hope. God, I hope.)
** This should allow for easy hypno status effect changes on the fly, with signals.
** These are meant to be stored in lists that are iterated over. They are not super useful on their own.
*/
/datum/aid
	var/aid_ID //The String ID of the aid. This is used to find/differentiate different sources of aid.

	/* CAP BONUSES:
	** Cap bonuses increase or decrease 
	** the MAX AMOUNT of a particular point type.
	** Positive values allow for more points, 
	** Negative values allow for less points.
	** Pretty self explanitory. */

	var/cap_scale_bonus // amount by which to increase the max scale.
	var/cap_relax_bonus //amount of bonus relax cap given.
	var/cap_resist_bonus //amount of bonus resistance cap given.

	/* FLAT POINT BONUSES
	** Flat point bonuses either give or remove a particular amount of points, from the actual values.
	** Positive values make sure you always stay at at least that value.
	** Negative values are subtracted from your value. Negative numbers are treated as zero for scale,
	** but are properly negative for relaxation and resistance. */

	var/scale_bonus //amount of bonus Scale given.
	var/relax_bonus //amount of bonus relaxation given. 
	var/resist_bonus //amount of bonus resistance given.

/datum/aid/New(var/id, list/bonuses)
	aid_ID = id
	if(bonuses.len == 6)
		cap_scale_bonus = bonuses[0]
		cap_relax_bonus = bonuses[1]
		cap_resist_bonus = bonuses[2]
		scale_bonus = bonuses[3]
		relax_bonus = bonuses[4]
		resist_bonus = bonuses[5]
		return
	//oopsie you did a fucky wucky haha

//check to see if the given ID is the same, if they are the same, return true.
/datum/aid/proc/delcheck(var/idToCheck)
	if(idToCheck == aid_ID)
		return TRUE
	return FALSE
	
	
	
