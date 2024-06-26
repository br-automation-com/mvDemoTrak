/*

https://github.com/hilch/TrakDiag

Helper Library for ACOPOStrak diagnosis

MIT License

Copyright (c) 2022 https://github.com/hilch

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

#include <bur/plctypes.h>
#include <cstring>
#include <cstdio>
#include <cctype>
#include <algorithm>

#ifdef __cplusplus
	extern "C"
	{
#endif
	#include "TrakDiag.h"
#ifdef __cplusplus
	};
#endif
/* Write status of 8 flags variable into log */
void TD_LogWatch8Flags(struct TD_LogWatch8Flags* inst)
{
	if( inst->Enable ){
		switch( inst->step ){
			case 0: /* startup */
			inst->Busy = 1;
			std::memset( &inst->fbLogWrite, 0, sizeof(inst->fbLogWrite) );
			std::strcpy( (char*) inst->fbLogWrite.Name, (char*) inst->LogName );
			inst->signalOld = !inst->Signal;
			inst->step = 10;
			break;


			case 10: /* check signal */
			inst->Valid = 1;
			if( inst->Signal != inst->signalOld){

				std::strcpy( (char*) inst->fbLogWrite.ObjectID, (char*) inst->SignalName );
				std::strcpy( (char*) inst->fbLogWrite.Ascii, "" );
				for( int n = 7; n>=0 ; --n ){
					if( inst->Flag[n][0] ){  /* flag used ? */
						char f[sizeof(inst->Flag[0])];
						bool bit = !!(inst->Signal & 1<<n);
						bool bitOld = !!(inst->signalOld & 1<<n);

						std::memset( (void*) &f, 0, sizeof(f) );
						/* use upper case letters for TRUE and lower case for FALSE */
						if( bit ) {
							std::transform( &inst->Flag[n][0], &inst->Flag[n][8], f, std::toupper );
						}
						else {
							std::transform( &inst->Flag[n][0], &inst->Flag[n][8], f, std::tolower );
						}
						/* add a star '*' as prefix if flag was changed */
						if( bit != bitOld ){
							std::strcat( (char*) inst->fbLogWrite.Ascii, "*" );
						}
						else {
							std::strcat( (char*) inst->fbLogWrite.Ascii, " " );
						}
						std::strcat( (char*) inst->fbLogWrite.Ascii, f );
						std::strcat( (char*) inst->fbLogWrite.Ascii, " " );
					}
				}
				inst->signalOld = inst->Signal;
				inst->fbLogWrite.EventID = inst->EventID;
				inst->fbLogWrite.Execute = 1;
				inst->Busy = 1;
				TD_LogWrite( &inst->fbLogWrite );
				if( inst->fbLogWrite.Done ){
					inst->Busy = 0;
					inst->fbLogWrite.Execute = 0;
					TD_LogWrite( &inst->fbLogWrite );
					inst->step = 10;
				}
				else if( inst->fbLogWrite.Error ){
					inst->Busy = 0;
					inst->StatusID = inst->fbLogWrite.StatusID;
					inst->fbLogWrite.Execute = 0;
					TD_LogWrite( &inst->fbLogWrite );
					inst->step = 9999;				
				}
			}			
			break;


			case 9999: /* error */
			inst->Valid = 0;
			inst->Busy = 0;
			inst->Error = 1;
			break;

		}
	}
	else {
		inst->Busy = 0;
		inst->Valid = 0;
		inst->StatusID = 0;
		inst->Error = 0;
		inst->step = 0;
	}
}
