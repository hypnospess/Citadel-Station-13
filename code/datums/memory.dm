/datum/memory
	var/name //the title of the memory.
	var/mem_text = "This memory is self-explanitory." //the actual text of the memory
	
	var/traumatic = FALSE //Is the memory traumatic?
	var/positive = FALSE //is the memory a positive one?
	var/is_antag = FALSE //is the memory antag-related?
	var/conscious = TRUE //is the memory conscious or unconscious?
	var/essential = FALSE //is the memory key to your identity?
	var/modified = FALSE //Has the memory been noticably modified? (random chance of gaining this on memory.force_modify)
	

	var/datum/mind/owner //The mind this memory is contained in.

/datum/memory/New(var/title, var/content)
	name = title
	if(content)
		mem_text = content


/datum/memory/proc/change_vals(var/trauma, var/posi, var/antag, var/essence, var/consc, var/modi)
	//set the bools for a memory. (values can be left unchanged by setting the value to "-")
	//this is almost certainly a shitty way of doing this, but whatever.
	if(trauma != "-")
		traumatic = trauma
	if(posi != "-")
		positive = posi
	if(antag != "-")
		is_antag = antag
	if(essence != "-")
		essential = essence
	if(consc != "-")
		conscious = consc
	if(modi != "-")
		modified = modi
	if(istype(owner))
		owner.update_memory_listing()

/datum/memory/proc/antagonize(var/bool)
	if (bool != TRUE || bool != FALSE)
		return
	else
	is_antag = bool
	if(istype(owner))
		owner.update_memory_listing()

/datum/memory/proc/traumatize(var/bool)
	if (bool != TRUE || bool != FALSE)
		return
	else
	traumatic = bool
	if(istype(owner))
		owner.update_memory_listing()

/datum/memory/proc/make_positive(var/bool)
	if (bool != TRUE || bool != FALSE)
		return
	else
	positive = bool
	if(istype(owner))
		owner.update_memory_listing()

/datum/memory/proc/modify(var/newtitle, var/newtext)
	//should be used for admin commands and internal use ONLY.
	name = newtitle
	if(newtext)
		mem_text = newtext
	if(istype(owner))
		owner.update_memory_listing

/datum/memory/proc/force_modify(var/newtitle, var/newtext)
	//this is like modify, but used specifically for memory modifying game mechanics
	//it has a chance of marking the memory as modified.
	name = newtitle
	if(newtext)
		mem_text = newtext
	var/modchance = rand(1,10)
	switch(rand)
	if(1)
		modified = TRUE
		//should also alert player their memories have been updated.
	if (istype(owner))
		owner.update_memory_listing()

/datum/memory/proc/wipe()
	if(is_antag == TRUE)
		return //can't remove antag memories
	name = "???"
	content = "This memory is distant and hazy..."
	traumatic = FALSE
	positive = FALSE
	modified = TRUE
	essential = FALSE
	//alert that mems updated
	if (istype(owner))
		owner.update_memory_listing()
