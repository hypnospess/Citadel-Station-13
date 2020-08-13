/datum/memory
	var/name //the title of the memory.
	var/mem_text //the actual text of the memory
	
	var/traumatic = FALSE //Is the memory traumatic?
	var/positive = FALSE //is the memory a positive one?
	var/is_antag = FALSE //is the memory antag-related?

/datum/memory/New(var/title, var/content)
	name = title
	mem_text = content

/datum/memory/proc/antagonize(var/bool)
	if (bool != TRUE || bool != FALSE)
		return
	else
	is_antag = bool

/datum/memory/proc/traumatize(var/bool)
	if (bool != TRUE || bool != FALSE)
		return
	else
	traumatic = bool

/datum/memory/proc/make_positive(var/bool)
	if (bool != TRUE || bool != FALSE)
		return
	else
	positive = bool
