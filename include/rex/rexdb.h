/*
 *      rexdb.h
 *
 *      Xircom REX 6000 Database Routines
 *
 *      $Id: rexdb.h,v 1.1 2001-07-02 07:08:40 dmarion Exp $
 *
 *	Written by Damjan Marion <dmarion@open.hr>
 *
 */


#ifndef _REXDB_H
#define _REXDB_H

#define REX_DB_OPEN			0xD4
#define REX_DB_CLOSE			0xD6
#define REX_DB_INSERTRECORD		0xD8
#define REX_DB_NEXTRECORD		0xE2
#define REX_DB_UPDATEFIELD		0xE8
#define REX_DB_BEGINTRANSACTION     	0xF6
#define REX_DB_ENDTRANSACTION       	0xF6
#define REX_DB_READTEXT             	0xEA
#define REX_DB_INSERTTEXT           	0xEA



/*
 *  Database types
 */

#define DBID_UNKNOWN			0
#define DBID_COMMONSEARCHHISTORY 	120
#define DBID_SHELLADDIN 		150
#define DBID_SETUPINFO  		160
#define DBID_DEVICEID   		170
#define DBID_ADDRESS    		1000
#define DBID_CALENDAR   		2000
#define DBID_TODO               	3000
#define DBID_MEMO                       4000
#define DBID_MAIL                       5000
#define DBID_DICTIONARY         	7000
#define DBID_CLOCK                      8000
#define DBID_PICTURE           		10000

extern unsigned int __LIB__ 	DbFindRecord(int, char, char, ... );
extern unsigned int __LIB__ 	DbReadField(int, int, ... );
extern unsigned long __LIB__	DbGetRecordCount( int );

/*
 * Functions via SYSCALLx
*/

#define DbOpen( arg1 )					SYSCALL1( REX_DB_OPEN, arg1 )
#define DbClose( arg1 )					SYSCALL1( REX_DB_CLOSE, arg1 )
#define DbNextRecord( arg1 )				SYSCALL1( REX_DB_NEXTRECORD, arg1 )

#endif /* _REX_H */
