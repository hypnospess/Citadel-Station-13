//thx 158~<3

/datum/trance_effect/smile
	wordlist = "smile|grin|happy|feeling good|bliss" //like in the velvet chords, we use regexes

/datum/trance_effect/smile/trigger(mob/living/carbon/C, datum/status_effect/hypno/H, msg)
	if(!istype(H) || !istype(C))
		return FALSE
	H.examine_text = "They're smiling widely. They're probably just happy to be here."
	//do a visual message to everyone nearby!
	if(!H.isSmiling)
		H.isSmiling = TRUE
		addtimer(CALLBACK(C, /atom/proc/visible_message, "[C] starts to grin happily! It looks like they're having a really good time.", "You smile as widely as you can! This is the happiest you've been in a long time."), 1)

/datum/trance_effect/laugh
	wordlist = "laugh|giggle|chuckle|guffaw|cackle|funny|silly|goofy"

/datum/trance_effect/laugh/trigger(mob/living/carbon/C, datum/status_effect/hypno/H, msg)
	if(!H.laughTimer)
		H.laughTimer = 150
		addtimer(CALLBACK(C, /atom/proc/audible_message, "[C] begins to giggle!", "Everything seems really funny all of a sudden!"), 1)

/datum/trance_effect/drool
	wordlist = "drool|drip|salivate|saliva|dribble"

/datum/trance_effect/lay
	wordlist = "lie down|lay down|recline|on the floor|on the ground|kneel|on your knees|on all fours"

/datum/trance_effect/relax
	wordlist = "relax|loose|limp|sink|slip|deep|drift"

/datum/trance_effect/relax/trigger(mob/living/carbon/C, datum/status_effect/hypno/H, msg)
	if(!istype(H) || !istype(C))
		return FALSE
	H.do_relaxation(TRUE)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, C, "You relax a little bit."), 1)

/datum/trance_effect/atease_words
	wordlist = "at ease|stop|back to normal"

/datum/trance_effect/scale
	wordlist = "how deep|how hypnotized|scale"

/datum/trance_effect/scale/trigger(mob/living/carbon/C, datum/status_effect/hypno/H, msg)
	if(!istype(H) || !istype(C))
		return FALSE
	addtimer(CALLBACK(C, /atom/movable/proc/say, "[H.scale]", null, list(), TRUE, null, FALSE, "hypnosis"), 1)

//more eventually
//earlystage compulsions (simple compulsions to act, very easy to comprehend)
/datum/trance_effect/flee
	wordlist = "go away|fuck off|piss off|flee|leave me alone"

/datum/trance_effect/walk
	wordlist = "walk|go|proceed|shuffle"

/datum/trance_effect/follow
	wordlist = "follow me|come with me|let's go"

//more eventually

//deeper compulsions
/datum/trance_effect/phobia
	wordlist = "is scary|is terrifying|horrifies you|is your greatest fear"

/datum/trance_effect/philia
	wordlist = "you love|you need|obessed with|craving|desiring|needing"

/datum/trance_effect/goal
	wordlist = "new objective|obey this command|unable to resist|compelled|word from hq|new goal" //shh stolen from velvet chords

/datum/trance_effect/restriction
	wordlist = "don't|stop|halt|cease|never"

//maybe more?

//deeper commands
//none yet
/datum/trance_effect/piss
	wordlist = "piss|take a leak|flood|pee|urinate"

//deepest compulsions
//none yet
/datum/trance_effect/gather_words
	wordlist = "retrieve|fetch|go get|pick up|gather"
