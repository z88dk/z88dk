/*
 *      rexdb.h
 *
 *      Xircom REX 6000 Database Routines
 *
 *      $Id: rexdb.h,v 1.2 2001-07-24 09:17:53 dmarion Exp $
 *
 *	Written by Damjan Marion <dmarion@open.hr>
 *
 */


#ifndef _REXDB_H
#define _REXDB_H

#define REX_DB_INITIALIZE               0xD0
#define REX_DB_CREATE                   0xD2
#define REX_DB_OPEN                     0xD4
#define REX_DB_CLOSE                    0xD6
#define REX_DB_INSERTRECORD             0xD8
#define REX_DB_DELETERECORD             0xDA
#define REX_DB_READRECORD               0xDC
#define REX_DB_NEXTRECORD               0xE2
#define REX_DB_PREVIOUSRECORD           0xE4
#define REX_DB_UPDATEFIELD              0xE8
#define REX_DB_TEXTOP                   0xEA
#define REX_DB_FLUSH                    0xEC
#define REX_DB_DESTROY                  0xF0
#define REX_DB_OPENSESSION              0xF2
#define REX_DB_MISC                     0xF6



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
#define DBID_WEB                        20000

extern unsigned int __LIB__ 	DbFindRecord(int, char, char, ... );
extern unsigned int __LIB__ 	DbReadField(int, int, ... );
extern unsigned long __LIB__	DbGetRecordCount( int );
extern unsigned int __LIB__     DbInsertRecord(int, ... );
extern unsigned int __LIB__     DbReadRecord(int, ... );
extern unsigned int __LIB__     DbUpdateRecord(int, ... );

/*
 * Functions via SYSCALLx
*/

#define DbInitialize( )                                 SYSCALL0( REX_DB_INITIALIZE )
#define DbCreate( arg1, arg2, arg3 )                    SYSCALL3( REX_DB_CREATE, arg1, arg2, arg3 )
#define DbOpen( arg1 )                                  SYSCALL1( REX_DB_OPEN, arg1 )
#define DbClose( arg1 )                                 SYSCALL1( REX_DB_CLOSE, arg1 )
#define DbDeleteRecord( arg1 )                          SYSCALL1( REX_DB_DELETERECORD, arg1 )
#define DbDestroy( arg1 )                               SYSCALL1( REX_DB_DESTROY, arg1 )
#define DbNextRecord( arg1 )                            SYSCALL1( REX_DB_NEXTRECORD, arg1 )
#define DbPreviousRecord( arg1 )                        SYSCALL1( REX_DB_PREVIOUSRECORD, arg1 )
#define DbFlush( )                                      SYSCALL0( REX_DB_FLUSH )
#define DbOpenSession( )                                SYSCALL1( REX_DB_OPENSESSION, 0 )
#define DbGetFieldSize( arg1, arg2, arg3 )              SYSCALL4( REX_DB_MISC, 0x03, arg1, arg2, arg3 )
#define DbBeginTransaction( )                           SYSCALL1( REX_DB_MISC, 0x07 )
#define DbCommitTransaction( )                          SYSCALL1( REX_DB_MISC, 0x08 )
#define DbRollbackTransaction( )                        SYSCALL1( REX_DB_MISC, 0x09 )
#define DbGetTransactionError( )                        SYSCALL1( REX_DB_MISC, 0x0A )
#define DbEndTransaction( arg1, arg2 )                  SYSCALL3( REX_DB_MISC, 0x0B, arg1 , arg2 )

#endif /* _REXDB_H */
