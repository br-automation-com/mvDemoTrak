
PROGRAM _CYCLIC
	(* Insert code here *)
	
	
	(***************************************************************)
	(*Mapping Error Reset*)
	IF gVisu.Cmd.ErrorReset THEN
		gVisu.Cmd.ErrorReset := FALSE; //reset command
		//mapp command to main structure -> Error Reset
		//gMachine.Cmd.ErrorReset := TRUE;
		gMachineErrorReset := TRUE;
	END_IF
	
	(* only for test without machine code*)
	TON_MachineErrorReset.IN := gMachineErrorReset;
	TON_MachineErrorReset(PT := T#100ms);
	IF TON_MachineErrorReset.Q THEN
		gMachineErrorReset := FALSE;
	END_IF
	
	(***************************************************************)
	(* Mapping for actual PLC Time *)
	fbDTGetTime(enable := TRUE);
	gVisu.Data.ActTime := fbDTGetTime.DT1;
	(***************************************************************)
	(* Set new time *)
	IF gVisu.Cmd.SetTime THEN
		gVisu.Cmd.SetTime := FALSE;
		fbDTSetTime(enable := TRUE , DT1 := gVisu.Data.SetTime );
	END_IF
	(***************************************************************)
	
	(*ClockPulse*)
	ClockPulse;
	gVisu.Data.ClockPuls.Slow := TP_PulseOnSlow.Q;
	gVisu.Data.ClockPuls.Medium := TP_PulseOnMed.Q;
	gVisu.Data.ClockPuls.Flash := TP_PulseOnFlash.Q;
	
END_PROGRAM
