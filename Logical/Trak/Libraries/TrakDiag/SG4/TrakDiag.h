/* Automation Studio generated header file */
/* Do not edit ! */
/* TrakDiag 2.01.0 */

#ifndef _TRAKDIAG_
#define _TRAKDIAG_
#ifdef __cplusplus
extern "C" 
{
#endif
#ifndef _TrakDiag_VERSION
#define _TrakDiag_VERSION 2.01.0
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
#ifdef _SG3
		#include "astime.h"
		#include "FileIO.h"
		#include "standard.h"
		#include "sys_lib.h"
		#include "brsystem.h"
		#include "ArEventLog.h"
		#include "DataObj.h"
		#include "AsHttp.h"
		#include "McBase.h"
		#include "McAcpTrak.h"
#endif
#ifdef _SG4
		#include "astime.h"
		#include "FileIO.h"
		#include "standard.h"
		#include "sys_lib.h"
		#include "brsystem.h"
		#include "ArEventLog.h"
		#include "DataObj.h"
		#include "AsHttp.h"
		#include "McBase.h"
		#include "McAcpTrak.h"
#endif
#ifdef _SGC
		#include "astime.h"
		#include "FileIO.h"
		#include "standard.h"
		#include "sys_lib.h"
		#include "brsystem.h"
		#include "ArEventLog.h"
		#include "DataObj.h"
		#include "AsHttp.h"
		#include "McBase.h"
		#include "McAcpTrak.h"
#endif


/* Constants */
#ifdef _REPLACE_CONST
 #define TD_MAX_SUPPORTED_SEGMENTS_ASM 255U
 #define TD_MAX_SUPPORTED_SHUTTLES_ASM 255U
#else
 _GLOBAL_CONST unsigned char TD_MAX_SUPPORTED_SEGMENTS_ASM;
 _GLOBAL_CONST unsigned char TD_MAX_SUPPORTED_SHUTTLES_ASM;
#endif




/* Datatypes and datatypes of function blocks */
typedef enum TD_SegErrorCommandEnum
{	TD_SEGERRCMD_SEGMENT,
	TD_SEGERRCMD_CHANNEL,
	TD_SEGERRCMD_ENCODER
} TD_SegErrorCommandEnum;

typedef struct TD_HttpServiceType
{	struct httpService fbHttpService;
	struct httpGetParamUrl fbGetParamUrl;
	plcstring urlParamBuffer[11];
	signed long tempDINT;
	plcstring serviceName[81];
	plcstring uri[257];
	struct httpRequestHeader_t requestHeader;
	plcstring requestData[2049];
	struct httpResponseHeader_t responseHeader;
	plcstring responseData[65537];
	struct httpStatistics_t statistics;
	unsigned short lastError;
} TD_HttpServiceType;

typedef struct TD_ServicesSegInfoType
{	unsigned short numberOfSegments;
	struct McSegmentType segment[256];
	struct McAcpTrakSegGetInfoType segmentInfo[256];
} TD_ServicesSegInfoType;

typedef struct TD_ServicesShuttleType
{	unsigned long index;
	unsigned char flags;
	McAxisPLCopenStateEnum plcOpenState;
	unsigned short segmentID;
	unsigned char segmentPosition;
} TD_ServicesShuttleType;

typedef struct TD_ServicesShuttlesType
{	unsigned char numberOfEntries;
	unsigned char numberOfActiveShuttles;
	struct TD_ServicesShuttleType shuttle[256];
} TD_ServicesShuttlesType;

typedef struct TD_RecorderSegInfoType
{	unsigned short numberOfSegments;
	unsigned char fill1;
	unsigned char fill2;
	struct McSegmentType segment[256];
	struct McAcpTrakSegGetInfoType segmentInfo[256];
} TD_RecorderSegInfoType;

typedef struct TD_LoggerEntryType
{	ArEventLogRecordIDType RecordID;
	ArEventLogRecordIDType OriginRecordID;
	signed long EventID;
	unsigned char Severity;
	plcstring ObjectID[37];
	plcstring Description[81];
	struct ArEventLogTimeStampType TimeStamp;
	plcdt LocalTime;
} TD_LoggerEntryType;

typedef struct TD_LogWrite
{
	/* VAR_INPUT (analog) */
	plcstring Name[11];
	signed long EventID;
	plcstring ObjectID[37];
	plcstring Ascii[121];
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	/* VAR (analog) */
	struct ArEventLogCreate fbLogCreate;
	struct ArEventLogGetIdent fbLogGetIdent;
	struct ArEventLogWrite fbLogWrite;
	unsigned short step;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Error;
} TD_LogWrite_typ;

typedef struct TD_LogWatchBOOL
{
	/* VAR_INPUT (analog) */
	plcstring LogName[11];
	plcstring SignalName[37];
	signed long EventID;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	/* VAR (analog) */
	unsigned short step;
	struct TD_LogWrite fbLogWrite;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit Signal;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
	/* VAR (digital) */
	plcbit signalOld;
} TD_LogWatchBOOL_typ;

typedef struct TD_LogWatch8Flags
{
	/* VAR_INPUT (analog) */
	unsigned char Signal;
	plcstring LogName[11];
	plcstring SignalName[37];
	signed long EventID;
	plcstring Flag[8][9];
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	/* VAR (analog) */
	unsigned char signalOld;
	unsigned short step;
	struct TD_LogWrite fbLogWrite;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
} TD_LogWatch8Flags_typ;

typedef struct TD_LogWatchDINT
{
	/* VAR_INPUT (analog) */
	signed long Signal;
	plcstring LogName[11];
	plcstring SignalName[37];
	signed long EventID;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	/* VAR (analog) */
	signed long signalOld;
	unsigned short step;
	struct TD_LogWrite fbLogWrite;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
} TD_LogWatchDINT_typ;

typedef struct TD_LogWatchSTRING
{
	/* VAR_INPUT (analog) */
	plcstring Signal[121];
	plcstring LogName[11];
	plcstring SignalName[37];
	signed long EventID;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	/* VAR (analog) */
	plcstring signalOld[121];
	unsigned short step;
	struct TD_LogWrite fbLogWrite;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
} TD_LogWatchSTRING_typ;

typedef struct TD_LoggerReadEntry
{
	/* VAR_INPUT (analog) */
	ArEventLogIdentType Ident;
	ArEventLogRecordIDType RecordID;
	/* VAR_OUTPUT (analog) */
	struct TD_LoggerEntryType Entry;
	signed long StatusID;
	/* VAR (analog) */
	struct ArEventLogRead fbRead;
	struct ArEventLogReadDescription fbReadDescription;
	struct ArEventLogReadObjectID fbReadObjectID;
	struct UtcDT_TO_LocalDTStructure fbUtcToLocalTime;
	struct DTStructure LocalTimeDTStructure;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Error;
	/* VAR (digital) */
	plcbit UtcToLocalTime_Done;
} TD_LoggerReadEntry_typ;

typedef struct TD_CrashReport
{
	/* VAR_INPUT (analog) */
	unsigned long pLoggerEntries;
	unsigned long SizeLoggerEntries;
	unsigned char thrSeverity;
	plcstring objectStartsWith1[6];
	plcstring objectStartsWith2[6];
	plctime observationPeriod;
	/* VAR_OUTPUT (analog) */
	unsigned short MaxEntries;
	unsigned short NbrOfEntries;
	signed long StatusID;
	/* VAR (analog) */
	unsigned short step;
	unsigned short index;
	struct ArEventLogGetIdent fbGetIdent;
	struct ArEventLogGetPreviousRecordID fbGetPreviousRecordID;
	struct ArEventLogGetLatestRecordID fbGetLatestRecordID;
	struct DTGetTime fbDTGetTime;
	struct TD_LoggerReadEntry fbReadEntry;
	struct TON tonDelayRead;
	plcdt eventTimeMinimum;
	unsigned long counterEntries;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Error;
} TD_CrashReport_typ;

typedef struct TD_SegCommandError
{
	/* VAR_INPUT (analog) */
	struct McSegmentType* Segment;
	enum TD_SegErrorCommandEnum Type;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	/* VAR (analog) */
	struct MC_BR_SegCommandError_AcpTrak fbSegCommandError;
	struct MC_BR_SegPowerOn_AcpTrak fbSegPowerOn;
	unsigned short step;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Error;
} TD_SegCommandError_typ;

typedef struct TD_Recorder
{
	/* VAR_INPUT (analog) */
	plcstring AssemblyName[33];
	unsigned long DataAddress;
	unsigned long DataSize;
	unsigned char UserDataSize;
	plcstring DataObjectName[11];
	plcstring FileDeviceName[33];
	unsigned char NumberOfCycles;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct TD_RecorderSegInfoType SegInfo;
	plcstring OutputFileName[256];
	/* VAR (analog) */
	plcstring svgFileName[33];
	unsigned short step;
	signed short currentRecord;
	unsigned short n;
	unsigned short refreshCycles;
	unsigned short cycleCounter;
	unsigned short maxRecords;
	struct DatObjInfo fbDatObjInfo;
	struct DatObjCreate fbDatObjCreate;
	struct DatObjDelete fbDatObjDelete;
	struct FileCreate fbFileCreate;
	struct FileClose fbFileClose;
	struct FileWriteEx fbFileWrite;
	struct FileOpen fbFileOpen;
	struct FileReadEx fbFileRead;
	struct MC_BR_AsmCopyShuttleData_AcpTrak fbCopyShuttleData;
	struct MC_BR_AsmGetSegment_AcpTrak fbGetSegment;
	struct MC_BR_SegGetInfo_AcpTrak fbSegGetInfo;
	struct McAssemblyType* pAssembly;
	struct TON tonTriggerDelay;
	struct RTInfo fbRtInfo;
	unsigned long tempudint;
	unsigned long pDataObject;
	unsigned long pBuffer;
	unsigned long pTimestamps;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit Trigger;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
	plcbit Saved;
} TD_Recorder_typ;

typedef struct TD_WebServices
{
	/* VAR_INPUT (analog) */
	plcstring AssemblyName[33];
	unsigned long DataAddress;
	unsigned long DataSize;
	unsigned char UserDataSize;
	plcstring DataObjectName[11];
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct TD_ServicesSegInfoType SegInfo;
	struct TD_ServicesShuttlesType ShuttleInfo;
	/* VAR (analog) */
	plcstring svgFileName[33];
	struct fiFILE_INFO infoSvgFile;
	plcstring acpTrakVersion[11];
	unsigned short step;
	unsigned short n;
	unsigned long tempudint;
	unsigned long refreshTimer;
	unsigned long hashShuttleInfo;
	struct TD_HttpServiceType webData;
	unsigned long pDataObject;
	struct DatObjInfo fbDatObjInfo;
	struct DatObjCreate fbDatObjCreate;
	struct DatObjDelete fbDatObjDelete;
	struct FileInfo fbFileInfo;
	struct FileClose fbFileClose;
	struct FileOpen fbFileOpen;
	struct FileReadEx fbFileRead;
	struct MC_BR_AsmGetSegment_AcpTrak fbGetSegment;
	struct MC_BR_SegGetInfo_AcpTrak fbSegGetInfo;
	struct McAssemblyType* pAssembly;
	struct RTInfo fbRtInfo;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
} TD_WebServices_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC void TD_LogWatchBOOL(struct TD_LogWatchBOOL* inst);
_BUR_PUBLIC void TD_LogWatch8Flags(struct TD_LogWatch8Flags* inst);
_BUR_PUBLIC void TD_LogWatchDINT(struct TD_LogWatchDINT* inst);
_BUR_PUBLIC void TD_LogWatchSTRING(struct TD_LogWatchSTRING* inst);
_BUR_PUBLIC void TD_LogWrite(struct TD_LogWrite* inst);
_BUR_PUBLIC void TD_CrashReport(struct TD_CrashReport* inst);
_BUR_PUBLIC void TD_SegCommandError(struct TD_SegCommandError* inst);
_BUR_PUBLIC void TD_LoggerReadEntry(struct TD_LoggerReadEntry* inst);
_BUR_PUBLIC void TD_Recorder(struct TD_Recorder* inst);
_BUR_PUBLIC void TD_WebServices(struct TD_WebServices* inst);
_BUR_PUBLIC plcbit TD_ascDT(plcdt DT1, unsigned long pString, unsigned char maxSize);
_BUR_PUBLIC unsigned short TD_filenameDT(unsigned long prefix, unsigned long pString, unsigned long maxSize);


#ifdef __cplusplus
};
#endif
#endif /* _TRAKDIAG_ */

