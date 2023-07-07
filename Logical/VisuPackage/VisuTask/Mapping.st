
ACTION MappingInit: 
	status := PV_xgetadr( ADR('AssCtrl:assemblyCtrl'), ADR(pAssemblyCtrl), ADR(assemblyCtrlDataLength) );
	IF status = 0 THEN
		assemblyCtrl ACCESS pAssemblyCtrl;
	END_IF
END_ACTION


ACTION MappingCyclic:
	IF assemblyCtrl.SizeOf = assemblyCtrlDataLength THEN
		(* Power Button *)
		IF gVisu.Cmd.DiagnosisPowerButton THEN
			IF NOT assemblyCtrl.Status.Ready THEN
				assemblyCtrl.Cmd.PowerOn := TRUE;
			END_IF
			gVisu.Cmd.DiagnosisPowerButton := FALSE;
		END_IF

		(* Play Button *)
		IF gVisu.Cmd.DiagnosisPlayButton THEN
			assemblyCtrl.Cmd.Start := TRUE;
			gVisu.Cmd.DiagnosisPlayButton := FALSE;
		END_IF

		(* Error Reset*)
		IF gVisu.Cmd.ErrorReset THEN
			gVisu.Cmd.ErrorReset := FALSE; //reset command
			assemblyCtrl.Cmd.Reset := TRUE;
			gMachineErrorReset := TRUE;
		END_IF

		(* Error Simulation *)
		CASE gVisu.Cmd.DiagnosisBreakDownIdx OF
			0: (* nothing *)

			1:
			assemblyCtrl.Cmd.SimSegmentError := TRUE;
			gVisu.Cmd.DiagnosisBreakDownIdx := 0;

			2:
			assemblyCtrl.Cmd.SimChannelError := TRUE;
			gVisu.Cmd.DiagnosisBreakDownIdx := 0;

			3:
			assemblyCtrl.Cmd.SimEncoderError := TRUE;
			gVisu.Cmd.DiagnosisBreakDownIdx := 0;

		END_CASE

	END_IF
END_ACTION


