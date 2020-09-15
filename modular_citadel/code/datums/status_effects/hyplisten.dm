//this is the listener portion of the hypno effect.
//not sure how this will work, but we shall see.

/*
	IMPORTANT: DIFFERENCE BETWEEN COMPULSIONS AND COMMANDS
	Commands are a one and done. You say it once, it has an effect. 
	That effect may be a simple action, 
	or it might be an aesthetic or vocal effect that can be cancelled.

	Compulsions are an extended effect! Think of them more like a task that requires involvement.
	They can be resist-mashed out of.

	Basically, if it's something that can be done on the spot, it's a command.
	If it's something that requires movement or significant involvement,
	or ACTIVE ROLEPLAY on the part of the victim, it's a compulsion.
*/

//here are the behavior states involved:
#define DEFAULT = 0 //the standard case, nothing happens.

/datum/component/hyplistener
	var/outputstate = DEFAULT //this is what actually determines what should be happening. It will be returned.
	var/mob/living/carbon/listener //this is the mob that this is attached to.
	var/status_effect/hypno/effect //this is the status effect that this is attached to
	
	
	//earlystage commands (mostly aesthetic, with a few exceptions)
	var/static/regex/smile_words = regex("smile|grin|happy|feeling good|bliss") //like in the velvet chords, we use regexes
	var/static/regex/laugh_words = regex("laugh|giggle|chuckle|guffaw|cackle|funny|silly|goofy")
	var/static/regex/drool_words = regex("drool|drip|salivate|saliva|dribble")
	var/static/regex/lay_words = regex("lie down|lay down|recline|on the floor|on the ground|kneel|on your knees|on all fours")
	var/static/regex/relax_words = regex("relax|loose|limp|sink|slip|deep|drift")
	//more eventually

	//earlystage compulsions (simple compulsions to act, very easy to comprehend)
	var/static/regex/flee_words = regex("go away|fuck off|piss off|flee|leave me alone")
	var/static/regex/walk_words = regex("walk|go|proceed|shuffle")
	var/static/regex/follow_words = regex("follow me|come with me|let's go")
	//more eventually

	//deeper compulsions
	var/static/regex/phobia_words = regex("is scary|is terrifying|horrifies you|is your greatest fear")
	var/static/regex/philia_words = regex("you love|you need|obessed with|craving|desiring|needing")
	var/static/regex/goal_words = regex("new objective|obey this command|unable to resist|compelled|word from hq|new goal") //shh stolen from velvet chords
	var/static/regex/restriction_words = regex("don't|stop|halt|cease|never")
	//maybe more?

	//deeper commands
	//none yet

	//deepest compulsions
	//none yet

	//deepest commands
	//none yet

	//constructor goes here
	
	/datum/component/hyplistener/Initialize()	//this is probably not gonna be the final init i am just putting it here for now
		if(!parent)
			return COMPONENT_INCOMPATIBLE

		RegisterSignal(parent,COMSIG_MOVABLE_HEAR, .proc/parse)

	/datum/component/hyplistener/proc/parse()
