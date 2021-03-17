/datum/mental/memory
	var/depth = 1 //value 1 to 5
	var/mood = 0 //0= neutral. 1= positive. 2= negative.
	var/stability = 1 //value 1 to 5
	var/title = "Default Memory Name"
	var/body = "This memory has no additional details."
	var/ailments = list(0)
	var/emotions = list(0)
	var/errormsg = 0 //we'll check a list of various error messages later

	oddities = list("","This memory feels... off.","It's fading fast.","I can barely remember this.","Wait, did that really happen?","Why did I enjoy that so much?","Why do I feel so unhappy?","Everything feels numb.","What?")
		//that's a list of all the memory "error" messages
	
//fuck. How does this work again?
/datum/mental/memory/New(ti,bo,mo,de,st,er,list/em,list/ai)
	. = ..()
	title = ti
	body = bo
	mood = mo
	depth = de
	stability = st
	errormsg = er
	emotions = em
	ailments = ai
