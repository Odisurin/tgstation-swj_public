/datum/round_event_control/jedi/imposter //Mirror Mania
	name = "Imposter Jedi"
	weight = 1
	typepath = /datum/round_event/jedi/imposter
	max_occurrences = 1
	earliest_start = 0 MINUTES

/datum/round_event/jedi/imposter/start()
	for(var/datum/mind/M in SSticker.mode.jedis)
		if(!ishuman(M.current))
			continue
		var/mob/living/carbon/human/W = M.current
		var/list/candidates = pollGhostCandidates("Would you like to be an imposter jedi?", ROLE_WIZARD)
		if(!candidates)
			return //Sad Trombone
		var/mob/dead/observer/C = pick(candidates)

		new /obj/effect/particle_effect/smoke(W.loc)

		var/mob/living/carbon/human/I = new /mob/living/carbon/human(W.loc)
		W.dna.transfer_identity(I, transfer_SE=1)
		I.real_name = I.dna.real_name
		I.name = I.dna.real_name
		I.updateappearance(mutcolor_update=1)
		I.domutcheck()
		I.key = C.key
		var/datum/antagonist/jedi/master = M.has_antag_datum(/datum/antagonist/jedi)
		if(!master.wiz_team)
			master.create_wiz_team()
		var/datum/antagonist/jedi/apprentice/imposter/imposter = new()
		imposter.master = M
		imposter.wiz_team = master.wiz_team
		master.wiz_team.add_member(imposter)
		I.mind.add_antag_datum(imposter)
		//Remove if possible
		SSticker.mode.apprentices += I.mind
		I.mind.special_role = "imposter"
		//
		I.log_message("is an imposter!", LOG_ATTACK, color="red") //?
		SEND_SOUND(I, sound('sound/effects/magic.ogg'))
