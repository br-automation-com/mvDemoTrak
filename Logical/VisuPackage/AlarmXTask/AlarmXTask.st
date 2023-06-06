(*****************************************************************************************************
* COPYRIGHT -- B&R
******************************************************************************************************
* Program:	AlarmXTask.st
* Author: 	Patrick Tisovec
* Created:	January 21, 2022
******************************************************************************************************
* Description:
* - AlarmX Task  Alarm management
*
******************************************************************************************************
* Version	| Date				| Author 				| Description
* ------------------------------------------------------------------------------------------------------
* V1.00		| 21-January-2022	| Patrick Tisovec	| Release version
******************************************************************************************************)

PROGRAM _INIT
	//nur Test für Alarmanzeige
	//gBreastVaccination.Status.ErrorID;//101010201 / 101020201
	//gPoxVaccination.Status.ErrorID; 	//202010402 202010403
	//gChainDrive.Status.ErrorID;				//253010201 / 253010202
	//gEyeVaccination.Status.ErrorID;		//151010306 / 151010307
	//gMachine.Status.ErrorID;

	tmpErrorID; //nur zum Test !!
	
	(*Alarm List Core*)
	fbMpAlarmXCore.Enable := TRUE;
	fbMpAlarmXCore.MpLink := ADR(gAlarmXCore);
	
	(*Alarm List UI*)
	fbMpAlarmXListUI.Enable := fbMpAlarmXCore.Active;
	fbMpAlarmXListUI.MpLink := ADR(gAlarmXCore);
	stAlListUIConnect.Language := 'en';
	fbMpAlarmXListUI.UIConnect := ADR(stAlListUIConnect);
	stAlListUISetup.AlarmListSize := 50;
	fbMpAlarmXListUI.UISetup := stAlListUISetup;
	
	(*Alarm History*)	
	fbMpAlarmXHistory.Enable := TRUE;
	fbMpAlarmXHistory.MpLink := ADR(gAlarmXHistory);	
		
	(*AcknowledgeAll*)	
	fbMpAlarmXAckAll.Enable := fbMpAlarmXCore.Active;
	fbMpAlarmXAckAll.MpLink := ADR(gAlarmXCore);
	
END_PROGRAM

PROGRAM _CYCLIC
	
	(*Call function blocks *)
	(*Alarm List Core*)
	fbMpAlarmXCore.Enable := TRUE;
	fbMpAlarmXCore.MpLink := ADR(gAlarmXCore);
	fbMpAlarmXCore();
	
	(*Alarm List UI*)
	fbMpAlarmXListUI.Enable := fbMpAlarmXCore.Active;
	fbMpAlarmXListUI.MpLink := ADR(gAlarmXCore);
	fbMpAlarmXListUI();

	(*Alarm History*)	
	fbMpAlarmXHistory.Enable := TRUE;
	fbMpAlarmXHistory.MpLink := ADR(gAlarmXHistory);
	fbMpAlarmXHistory();
	
	(* check faling trigger from ErrorReset *) 
	//IF EDGENEG(gMachine.Cmd.ErrorReset) THEN
	IF EDGENEG (gMachineErrorReset) THEN
		TON_ErrorReset.IN:=  TRUE;
	END_IF	
	(* delay time to acknowledge all errors *)
	TON_ErrorReset(PT := T#500ms);
	
	(*Only for demo*)
	IF gMachineErrorReset THEN 
		tmpErrorID := 0;
	END_IF

	(*AcknowledgeAll*)	
	fbMpAlarmXAckAll.Enable := fbMpAlarmXCore.Active;
	fbMpAlarmXAckAll.MpLink := ADR(gAlarmXCore);
	fbMpAlarmXAckAll.Execute := TON_ErrorReset.Q;
	fbMpAlarmXAckAll();
	IF fbMpAlarmXAckAll.CommandDone THEN
		TON_ErrorReset.IN :=FALSE;
	END_IF
	
	
	(*Mapping for Visu*)
	gVisu.Data.VisAlarms.PendingAlarms := fbMpAlarmXCore.PendingAlarms;
	gVisu.Data.VisAlarms.Visible := (fbMpAlarmXCore.PendingAlarms > 0) AND gVisu.Para.ClientInfo[0].isValid ;
	
	(*Check Alarm Reaction*)
	AlarmStatus := ALARM_OK;
	IF (MpAlarmXCheckReaction(gAlarmXCore,'ActWarning')) THEN //severity 10
		AlarmStatus := ALARM_WARNING;
	END_IF
	IF (MpAlarmXCheckReaction(gAlarmXCore,'ActErrorMed')) THEN //severity 50
		AlarmStatus := ALARM_MED;
	END_IF
	IF (MpAlarmXCheckReaction(gAlarmXCore,'ActError')) THEN //severity 100
		AlarmStatus := ALARM_ERROR;
	END_IF
	
	
	(* AlarmListWidget filtered by Categories*)
	//no filter
	IF (gVisu.Para.AlListBtnFilterIndx = 0) THEN
		brsstrcpy(ADR(gVisu.Data.AlListFilterConfiguration), ADR('[]'));
	//Warnings
	ELSIF (gVisu.Para.AlListBtnFilterIndx = 1) THEN
		brsstrcpy(ADR(gVisu.Data.AlListFilterConfiguration), ADR('[{"value":"0","conditionType":"==","columnType":"cat"}]'));
	//Medium Alarms
	ELSIF (gVisu.Para.AlListBtnFilterIndx = 2) THEN
		brsstrcpy(ADR(gVisu.Data.AlListFilterConfiguration), ADR('[{"value":"1","conditionType":"==","columnType":"cat"}]'));
	ELSIF (gVisu.Para.AlListBtnFilterIndx = 3) THEN
	//Alarms
		brsstrcpy(ADR(gVisu.Data.AlListFilterConfiguration), ADR('[{"value":"2","conditionType":"==","columnType":"cat"}]'));
	END_IF
	
	
	(* AlarmHistoryWidget filtered by Categories*)
	//no filter
	IF (gVisu.Para.AlHistBtnFilterIndx = 0) THEN
		brsstrcpy(ADR(gVisu.Data.AlHistFilterConfiguration), ADR('[]'));
	//Warnings
	ELSIF (gVisu.Para.AlHistBtnFilterIndx = 1) THEN
		brsstrcpy(ADR(gVisu.Data.AlHistFilterConfiguration), ADR('[{"value":"0","conditionType":"==","columnType":"cat"}]'));
	//Medium Alarms
	ELSIF (gVisu.Para.AlHistBtnFilterIndx = 2) THEN
		brsstrcpy(ADR(gVisu.Data.AlHistFilterConfiguration), ADR('[{"value":"1","conditionType":"==","columnType":"cat"}]'));
	ELSIF (gVisu.Para.AlHistBtnFilterIndx = 3) THEN
	//Alarms
		brsstrcpy(ADR(gVisu.Data.AlHistFilterConfiguration), ADR('[{"value":"2","conditionType":"==","columnType":"cat"}]'));
	END_IF
	
	
END_PROGRAM

PROGRAM _EXIT
	(*Alarm List Core*)
	fbMpAlarmXCore.Enable := FALSE;;
	fbMpAlarmXCore();
	
	(*Alarm List UI*)
	fbMpAlarmXListUI.Enable := FALSE;
	fbMpAlarmXListUI();

	(*Alarm History*)	
	fbMpAlarmXHistory.Enable := FALSE;
	fbMpAlarmXHistory();
	
	(*AcknowledgeAll*)	
	fbMpAlarmXAckAll.Enable := FALSE;
	fbMpAlarmXAckAll();
	
END_PROGRAM