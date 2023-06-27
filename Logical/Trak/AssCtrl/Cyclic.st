
PROGRAM _CYCLIC

	fbLogStep.EventID := TRAK_BASIC_INFO_ID;

	CASE step OF
		ASM_INIT:
		fbGetInfo( Execute := FALSE ); (* reset fb *)
		fbGetInfo( Execute := TRUE );
		fbPowerOn( Execute := FALSE ); (* reset fb *)
		fbPowerOff( Execute := FALSE ); (* reset fb *)
		step := ASM_GET_INFO;

			
		ASM_GET_INFO:
		fbLogStep.Signal := 'ASM_GET_INFO';
		IF fbGetInfo.Done THEN
			fbGetInfo( Execute := FALSE ); (* reset fb *)
			assemblyCtrl.Status.SimulationOnPlcMode := fbGetInfo.AssemblyInfo.SimulationOnPlcMode;
			step := ASM_W_READY_FOR_POWER_ON;
		ELSIF fbGetInfo.Error THEN
			fbGetInfo( Execute := FALSE ); (* reset fb *)
			step := ASM_ERR_GET_INFO;
			fbLogStep.EventID := TRAK_BASIC_ERROR_ID;
			fbLogStep.Signal := 'ASM_ERR_GET_INFO';
		ELSE (* busy *)
			fbGetInfo();
		END_IF

			
		ASM_W_READY_FOR_POWER_ON:
		fbLogStep.Signal := 'ASM_W_READY_FOR_POWER_ON';
		IF assemblyCtrl.Status.Info.ReadyForPowerOn THEN
			IF assemblyCtrl.Status.Info.PowerOn THEN
				step := ASM_POWER_IS_ON;
			ELSE
				step := ASM_POWER_IS_OFF;
			END_IF
		END_IF


		ASM_POWER_IS_OFF:
		fbLogStep.Signal := 'ASM_POWER_IS_OFF';
		IF assemblyCtrl.Cmd.PowerOn THEN
			assemblyCtrl.Cmd.PowerOn := FALSE;
			fbPowerOn( Execute := TRUE );
			step := ASM_W_POWER_ON;
		END_IF
	
			
		ASM_ADD_SIM_SHUTTLES:
		fbLogStep.Signal := 'ASM_ADD_SIM_SHUTTLES';
		IF fbAddSimShuttle.Done THEN
			fbAddSimShuttle( Execute := FALSE ); (* reset fb *)
			IF assemblyCtrl.Status.Info.ShuttlesCount >= assemblyCtrl.Para.NumberOfSimulatedShuttles OR assemblyCtrl.Para.NumberOfSimulatedShuttles = 0 THEN	
				step := ASM_POWER_IS_ON;
			ELSE
				fbAddSimShuttle.Position := fbAddSimShuttle.Position + 0.06;
				fbAddSimShuttle( Execute := TRUE );
			END_IF
		ELSIF fbAddSimShuttle.Error THEN
			fbAddSimShuttle( Execute := FALSE ); (* reset fb *)
			step := ASM_ERR_ADDING_SHUTTLE;
			fbLogStep.EventID := TRAK_BASIC_ERROR_ID;
			fbLogStep.Signal := 'ASM_ERR_ADDING_SHUTTLE';
		ELSE (* busy *)
			fbAddSimShuttle();
		END_IF
			


		ASM_W_POWER_ON:
		fbLogStep.Signal := 'ASM_W_POWER_ON';
		IF fbPowerOn.Done AND assemblyCtrl.Status.Info.PowerOn THEN
			fbPowerOn( Execute := FALSE );  (* reset fb *)
			IF assemblyCtrl.Status.Info.ShuttlesCount >= assemblyCtrl.Para.NumberOfSimulatedShuttles THEN	
				step := ASM_POWER_IS_ON;
			ELSE
				fbAddSimShuttle( Execute := FALSE ); (* reset fb *)
				fbAddSimShuttle( Execute := TRUE );
				step := ASM_ADD_SIM_SHUTTLES;
			END_IF
		ELSIF fbPowerOn.Error THEN
			fbPowerOn( Execute := FALSE );  (* reset fb *)
			step := ASM_ERR_POWERING_ON;
			fbLogStep.EventID := TRAK_BASIC_ERROR_ID;
			fbLogStep.Signal := 'ASM_ERR_POWERING_ON';
		ELSE (* busy *)
			fbPowerOn();
		END_IF

			
			

		ASM_POWER_IS_ON:
		fbLogStep.Signal := 'ASM_POWER_IS_ON';
		IF NOT assemblyCtrl.Status.Info.PowerOn THEN
			step := ASM_POWER_IS_OFF;
		ELSIF assemblyCtrl.Cmd.PowerOff THEN
			assemblyCtrl.Cmd.PowerOff := FALSE;
			fbPowerOff( Execute := TRUE );
			step := ASM_W_POWER_OFF;
		ELSIF assemblyCtrl.Cmd.Start THEN
			assemblyCtrl.Cmd.Start := FALSE;
			fbStartShuttles( Execute := FALSE ); (* reset fb *)
			fbStartShuttles( Execute := TRUE ); (* reset fb *)
			step := ASM_START_MOVEMENT;
		ELSIF assemblyCtrl.Cmd.SimSegmentError THEN
			assemblyCtrl.Cmd.SimSegmentError := FALSE;
			fbSegCommandError( Segment := ADR(gSegB7), Type := TD_SEGERRCMD_SEGMENT, Execute := FALSE );
			fbSegCommandError( Execute := TRUE );
			step := ASM_SIMULATE_ERROR;
		ELSIF assemblyCtrl.Cmd.SimChannelError THEN
			assemblyCtrl.Cmd.SimChannelError := FALSE;
			fbSegCommandError( Segment := ADR(gSegB7), Type := TD_SEGERRCMD_CHANNEL, Execute := FALSE );
			fbSegCommandError( Execute := TRUE );
			step := ASM_SIMULATE_ERROR;
		ELSIF assemblyCtrl.Cmd.SimEncoderError THEN
			assemblyCtrl.Cmd.SimEncoderError := FALSE;
			fbSegCommandError( Segment := ADR(gSegB7), Type := TD_SEGERRCMD_ENCODER, Execute := FALSE );
			fbSegCommandError( Execute := TRUE );
			step := ASM_SIMULATE_ERROR;
		END_IF

		
		ASM_START_MOVEMENT:
		fbLogStep.Signal := 'ASM_START_MOVEMENT';
		IF fbStartShuttles.Done THEN
			fbStartShuttles( Execute := FALSE ); (* reset fb *)
			step := ASM_POWER_IS_ON;			
		ELSIF fbStartShuttles.Error THEN
			fbStartShuttles( Execute := FALSE ); (* reset fb *)	
			step := ASM_ERR_START_MOVEMENT;
			fbLogStep.EventID := TRAK_BASIC_ERROR_ID;
			fbLogStep.Signal := 'ASM_ERR_START_MOVEMENT';		
		ELSE (* busy *)
			fbStartShuttles();
		END_IF


		ASM_SIMULATE_ERROR:
		fbLogStep.Signal := 'ASM_SIMULATE_ERROR';
		IF fbSegCommandError.Done THEN
			fbSegCommandError( Execute := FALSE );
			step := ASM_POWER_IS_ON;
		ELSIF fbSegCommandError.Error THEN
			fbSegCommandError( Execute := FALSE );
			step := ASM_POWER_IS_ON;
//			step := ASM_ERR_SIMULATE_ERROR;
//			fbLogStep.EventID := TRAK_BASIC_ERROR_ID;
//			fbLogStep.Signal := 'ASM_ERR_SIMULATE_ERROR';
		ELSE (* busy *)
			fbSegCommandError();
		END_IF


		ASM_W_POWER_OFF:
		fbLogStep.Signal := 'ASM_W_POWER_OFF';
		IF fbPowerOff.Done OR  NOT assemblyCtrl.Status.Info.PowerOn THEN
			step := ASM_POWER_IS_OFF;
			fbPowerOff( Execute := FALSE ); (* reset fb *)
		ELSIF fbPowerOff.Error THEN
			fbPowerOff( Execute := FALSE ); (* reset fb *)
			step := ASM_ERR_POWERING_OFF;
			fbLogStep.EventID := TRAK_BASIC_ERROR_ID;
			fbLogStep.Signal := 'ASM_ERR_POWERING_OFF';
		ELSE (* busy *)
			fbPowerOff();
		END_IF


		ASM_ERR_GET_INFO..ASM_ERR_GENERAL:


	END_CASE

	assemblyCtrl.Status.Step := step;
	fbLogStep(); (* log steps *)


	fbReadStatus();
	assemblyCtrl.Status.Disabled  	:= fbReadStatus.AssemblyDisabled;
	assemblyCtrl.Status.ErrorStop 	:= fbReadStatus.AssemblyErrorStop;
	assemblyCtrl.Status.Homing 		:= fbReadStatus.AssemblyHoming;
	assemblyCtrl.Status.Stopping 	:= fbReadStatus.AssemblyStopping;
	assemblyCtrl.Status.Ready 	  	:= fbReadStatus.AssemblyReady;

	fbReadInfo();
	assemblyCtrl.Status.Info := fbReadInfo.AssemblyInfo;


	fbRecorder( Trigger := assemblyCtrl.Status.ErrorStop );
	fbWebServices();


	fbLogResetStep.EventID := TRAK_BASIC_INFO_ID;
	CASE assemblyCtrl.Status.ResetStep OF
		ASMR_NO_ERROR:
		fbLogResetStep.Signal := 'ASMR_NO_ERROR';
		IF assemblyCtrl.Status.ErrorStop THEN
			fbAsmReset( Execute := FALSE ); (* reset fb *)
			assemblyCtrl.Cmd.Reset := FALSE;
			assemblyCtrl.Status.ResetStep := ASMR_W_ACKNOWLEDGE;
		END_IF


		ASMR_W_ACKNOWLEDGE:
		fbLogResetStep.Signal := 'ASMR_W_ACKNOWLEDGE';
		IF assemblyCtrl.Cmd.Reset THEN
			assemblyCtrl.Cmd.Reset := FALSE;
			fbAsmReset( Execute := TRUE ); (* reset fb *)
			assemblyCtrl.Status.ResetStep := ASMR_RESET;
		END_IF


		ASMR_RESET:
		fbLogResetStep.Signal := 'ASMR_RESET';
		IF fbAsmReset.Done THEN
			fbAsmReset( Execute := FALSE ); (* reset fb *)
			assemblyCtrl.Status.ResetStep := ASMR_NO_ERROR;
		ELSIF fbAsmReset.Error THEN
			fbAsmReset( Execute := FALSE ); (* reset fb *)
			assemblyCtrl.Status.ResetStep := ASMR_INTERNAL_ERROR;
			fbLogResetStep.EventID := TRAK_BASIC_ERROR_ID;
			fbLogResetStep.Signal := 'ASMR_INERNAL_ERROR';
		ELSE (* busy *)
			fbAsmReset();
		END_IF

		ASMR_INTERNAL_ERROR:

		
	END_CASE
	 
	fbLogResetStep();

END_PROGRAM
