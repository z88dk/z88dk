/***************************************************************
 *		Database.h
 *			Header for Rex addin program.
 *
 ***************************************************************/
#ifndef __DATABASE__
#define __DATABASE__

/*----- field types -----*/
#define DB_INT8					1
#define DB_INT16				2
#define DB_INT32				3
#define DB_FXDSTR				11
#define DB_FXDDAT				12
#define DB_VARSTR				21
#define DB_VARDAT				22
#define DB_RECID				90

/*----- error codes -----*/
#define DB_ERROR				-1
#define DB_ERR_SYS				-2
#define DB_ERR_PARM				-3
#define DB_STORAGE_FULL				-4
#define DB_CACHE_OVERFLOW			-5
#define DB_OUT_OF_MEMORY			-6
#define DB_REC_BUF_OVERFLOW			-7
#define DB_NOT_FOUND				-8
#define DB_DUPLICATE_KEYS			-9
#define DB_DBID_USED				-10
#define DB_NO_MORE_RECORD			-11
#define DB_NO_CURRENT_REC			-12
#define DB_ERR_SOFFS				-13
#define DB_ILLEGAL_OPERATION			-14
#define DB_ERR_COMM				-15
#define DB_ERR_FILE				-16
#define DB_NOT_IMPLEMENTED			-17

/*----- max index field size -----*/
#define DB_MAX_SIZE_32				5
#define DB_MAX_SIZE_64				6
#define DB_MAX_SIZE_128				7
#define DB_MAX_SIZE_256				8
#define DB_MAX_SIZE_512				9
																	

/*----- field definition -----*/
typedef struct tDbFieldDef {
	unsigned char		type;			/* field type */
	unsigned char		size;			/* field size */
} tDbFieldDef;

/*----- index field definition -----*/
typedef struct tDbIndexFieldDef {
	unsigned char		field_no;		/* field no. */
	unsigned char		ordering_type;		/* ordering type */
	unsigned char		max_size;		/* maximum size for index */			/*2000.04.13*/
} tDbIndexFieldDef;

/*----- index definition -----*/
typedef struct tDbIndexDef {
	tDbIndexFieldDef	*fields;		/* array of field def. */
} tDbIndexDef;



/*
 *  Database IDs
 */

#define DBID_UNKNOWN			0
#define DBID_COMMONSEARCHHISTORY 	120
#define DBID_SHELLADDIN 		150
#define DBID_SETUPINFO  		160
#define DBID_DEVICEID   		170
#define DBID_ADDRESS    		1000
#define DBID_CALENDAR   		2000
#define DBID_CALENDAR_STATUS		2001
#define DBID_CALENDAR_ALARM		2002
#define DBID_CALENDAR_TEXT		2004
#define DBID_TASK               	3000
#define DBID_TASK_STATUS		3001
#define DBID_TASK_2			3002	//unknown
#define DBID_TASK_3			3003	//unknown
#define DBID_TASK_TEXTINF		3004
#define DBID_MEMO                       4000
#define DBID_MEMO_STATUS		4001
#define DBID_MEMO_CATEGORY		4002
#define DBID_MEMO_CATLINK		4003
#define DBID_MEMO_TEXTINF		4004
#define DBID_MAIL                       5000
#define DBID_DICTIONARY         	7000
#define DBID_CLOCK                      8000
#define DBID_PICTURE           		10000
#define DBID_REXPENSE_LIST1		10100
#define DBID_REXPENSE_LIST2		10200
#define DBID_REXPENSE_LIST3		10300
#define DBID_REXPENSE_LIST4		10400
#define DBID_REXPENSE_LIST5		10500
#define DBID_WEB                        20000


#define DS_DB_INITIALIZE               	0xD0
#define DS_DB_CREATE                   	0xD2
#define DS_DB_OPEN                     	0xD4
#define DS_DB_CLOSE                    	0xD6
#define DS_DB_INSERT_RECORD             0xD8
#define DS_DB_DELETE_RECORD             0xDA
#define DS_DB_READ_RECORD               0xDC
#define DS_DB_NEXT_RECORD               0xE2
#define DS_DB_PREVIOUS_RECORD           0xE4
#define DS_DB_UPDATE_FIELD              0xE8
#define DS_DB_TEXT_OP                   0xEA
#define DS_DB_FLUSH                    	0xEC
#define DS_DB_DESTROY                  	0xF0
#define DS_DB_OPEN_SESSION              0xF2
#define DS_DB_MISC                     	0xF6


extern unsigned int __LIB__ 	DbFindRecord(int, char, char, ... );
extern unsigned long __LIB__	DbGetRecordCount( int );
extern unsigned int __LIB__     DbInsertRecord(int, ... );
extern unsigned int __LIB__     DbReadRecord(int, ... );
extern unsigned int __LIB__     DbUpdateRecord(int, ... );
extern unsigned int __LIB__ 	DbReadField(int, int, ... );
extern unsigned int __LIB__	DbUpdateField(int, int, ... );
extern unsigned int __LIB__	DbReadText(int, ... );
extern unsigned int __LIB__	DbInsertText(int, ... );
extern unsigned int __LIB__	DbDeleteText(int, ... );

/*
 * Functions via SYSCALLx
*/

#define DbInitialize( )                                 syscall0( DS_DB_INITIALIZE )
#define DbCreate( arg1, arg2, arg3 )                    syscall3( DS_DB_CREATE, arg1, arg2, arg3 )
#define DbOpen( arg1 )                                  syscall1( DS_DB_OPEN, arg1 )
#define DbClose( arg1 )                                 syscall1( DS_DB_CLOSE, arg1 )
#define DbDeleteRecord( arg1 )                          syscall1( DS_DB_DELETE_RECORD, arg1 )
#define DbDestroy( arg1 )                               syscall1( DS_DB_DESTROY, arg1 )
#define DbNextRecord( arg1 )                            syscall1( DS_DB_NEXT_RECORD, arg1 )
#define DbPreviousRecord( arg1 )                        syscall1( DS_DB_PREVIOUS_RECORD, arg1 )
#define DbFlush( )                                      syscall0( DS_DB_FLUSH )
#define DbOpenSession( )                                syscall1( DS_DB_OPEN_SESSION, 0 )
#define DbGetFieldSize( arg1, arg2, arg3 )              syscall4( DS_DB_MISC, 0x03, arg1, arg2, arg3 )
#define DbBeginTransaction( )                           syscall1( DS_DB_MISC, 0x07 )
#define DbCommitTransaction( )                          syscall1( DS_DB_MISC, 0x08 )
#define DbRollbackTransaction( )                        syscall1( DS_DB_MISC, 0x09 )
#define DbGetTransactionError( )                        syscall1( DS_DB_MISC, 0x0A )
#define DbEndTransaction( arg1, arg2 )                  syscall3( DS_DB_MISC, 0x0B, arg1 , arg2 )


#endif


