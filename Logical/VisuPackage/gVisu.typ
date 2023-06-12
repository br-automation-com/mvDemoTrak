(*VISU INTERFACE - gVisu.typ*)
(**** created B&R 2023 ****)
(*35453454*)

TYPE
	gVisu_type : {REDUND_UNREPLICABLE} 	STRUCT 
		Cmd : {REDUND_UNREPLICABLE} Cmd_Visu_type; (*Commands from HMI to PLC*)
		Para : {REDUND_UNREPLICABLE} Para_Visu_type; (*Parameters from HMI toPLC*)
		Data : {REDUND_UNREPLICABLE} Data_Visu_type; (*Data from PLC to HMI*)
	END_STRUCT;
	Cmd_Visu_type : 	STRUCT  (*Commands from HMI to PLC*)
		SetTime : BOOL; (*Set new time*)
		ErrorReset : BOOL; (*Error Reset*)
		DiagnosisStopButton : BOOL; (*Diagnosis Stop Button*)
		DiagnosisPlayButton : BOOL; (*Diagnosis Play Button*)
		DiagnosisBreakDownIdx : USINT; (*Diagnosis Breakdown - ButtonBar selected Index*)
	END_STRUCT;
	Para_Visu_type : 	STRUCT  (*Parameters from HMI toPLC*)
		ClientInfo : ARRAY[0..1]OF ClientInfo_typ; (*Client Info*)
		AlListBtnFilterIndx : USINT; (*ButonBar Index for AlListFilter*)
		AlHistBtnFilterIndx : USINT; (*ButonBar Index for AlHistoryFilter*)
	END_STRUCT;
	Data_Visu_type : 	STRUCT  (*Data from PLC to HMI*)
		ActTime : DATE_AND_TIME; (*actual server time*)
		SetTime : DATE_AND_TIME;
		VisAlarms : VisAlarms_type;
		ClockPuls : ClockPuls_type; (*ClockPulse*)
		AlListFilterConfiguration : STRING[100]; (*Al List Filter Configuration*)
		AlHistFilterConfiguration : STRING[100]; (*Al History Filter Configuration*)
	END_STRUCT;
	ClientInfo_typ : {REDUND_UNREPLICABLE} 	STRUCT  (*parameter structure from Visu/ ClientInfo*)
		isValid : {REDUND_UNREPLICABLE} BOOL;
		userId : {REDUND_UNREPLICABLE} STRING[80];
		ipAddress : {REDUND_UNREPLICABLE} STRING[15];
		languageId : {REDUND_UNREPLICABLE} STRING[2];
		userAgent : {REDUND_UNREPLICABLE} STRING[80];
		currentPageId : {REDUND_UNREPLICABLE} STRING[80];
		screenResolution : {REDUND_UNREPLICABLE} STRING[32];
		activityCount : {REDUND_UNREPLICABLE} UDINT;
	END_STRUCT;
	VisAlarms_type : 	STRUCT 
		Visible : BOOL;
		PendingAlarms : UDINT;
	END_STRUCT;
	ClockPuls_type : 	STRUCT 
		Slow : BOOL;
		Medium : BOOL;
		Flash : BOOL;
	END_STRUCT;
END_TYPE
