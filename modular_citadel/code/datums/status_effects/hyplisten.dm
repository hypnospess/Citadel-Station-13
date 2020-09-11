//this is the listener portion of the hypno effect.
//not sure how this will work, but we shall see.

//here are the behavior states involved:
#define DEFAULT = 0 //the standard case, nothing happens.

/datum/hyplistener
	var/outputstate = DEFAULT //this is what actually determines what should be happening. It will be returned.
	var/static/regex/walk_words = regex("walk|go|proceed|shuffle")	//like in the velvet chords, we use regexes
	var/static/regex/follow_words = regex("follow me|come with me|let's go")
	var/static/regex/phobia_words = regex("is scary|is terrifying|horrifies you|is your greatest fear")
	var/static/regex/philia_words = regex("you love|you need|obessed with|craving|desiring|needing")
	var/static/regex/goal_words = regex("new objective|obey this command|unable to resist|compelled|word from hq|new goal") //shh stolen from velvet chords
	//earlystage commands
	var/static/regex/smile_words = regex("smile|grin|happy|feeling good|bliss")
	var/static/regex/laugh_words = regex
