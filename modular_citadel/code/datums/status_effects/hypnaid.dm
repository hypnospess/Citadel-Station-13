/*
** This datum deals with hypnotic aids.
** It's basically just a package for data, that makes everyone's lives easier.
** (I hope. God, I hope.)
** This should allow for easy hypno status effect changes on the fly, with signals.
** These are meant to be stored in lists that are iterated over. They are not super useful on their own.
*/
/datum/aid
	var/aid_ID //The String ID of the aid. This is used to find/differentiate different sources of aid.

	var/list/bonuslist //list of bonuses

	var/list/desclist //2d list of dialogue
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
	PullDialogue()
	if(bonuses.len == 6)
		bonuslist = bonuses
		return
	//oopsie you did a fucky wucky haha

//check to see if the given ID is the same, if they are the same, return true.
/datum/aid/proc/delcheck(var/idToCheck)
	if(idToCheck == aid_ID)
		return TRUE
	return FALSE

//pull dialogue from the file. basically, searches for the id, and then throws together the dialogue list.
/datum/aid/proc/PullDialogue()
	var/textfile = "modular_citadel/code/datums/status_effects/hypdialogue.txt"
	var/list/file_lines = world.file2list(textfile)
	var/found_id = FALSE
	var/num_lines = 0
	for(var/line in file_lines)
		//ignoring comments:
		if(findtextEx(line,"**",1,3))
			//ok move on
			continue
		else if(findtextEx(line,">",1,2))
			//wait, how to get substring,
			var/to_check = copytext(line,2)
			if(aid_ID == to_check)
				found_id = TRUE
				if(num_lines)
					//what? this should not happen. bleh, error!!
					continue
				num_lines = 1
				continue
		else if(num_lines)
			if(num_lines > 5)
				num_lines = 0
				continue
			var/list/altlines = splittext(line,"|")
			desclist[num_lines] = altlines
			num_lines ++
	if(!found_id)
		//we couldn't find this id. Output something.
		return
