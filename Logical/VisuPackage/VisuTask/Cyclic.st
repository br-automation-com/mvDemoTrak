
PROGRAM _CYCLIC
	(* Insert code here *)
	 
	(***************************************************************)
	(* Mapping for actual PLC Time *)
	fbDTGetTime(enable := TRUE);
	gVisu.Data.ActTime := fbDTGetTime.DT1;
	(***************************************************************)
	(*ClockPulse*)
	ClockPulse;
	gVisu.Data.ClockPuls.Slow := TP_PulseOnSlow.Q;
	gVisu.Data.ClockPuls.Medium := TP_PulseOnMed.Q;
	gVisu.Data.ClockPuls.Flash := TP_PulseOnFlash.Q;
	
END_PROGRAM
