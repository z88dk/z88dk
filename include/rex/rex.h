/*
 *      rex.h
 *
 *      Xircom REX 6000 Routines
 *
 *	$Id: rex.h,v 1.1 2001-06-25 13:06:09 dom Exp $
 *
 *	From Damjan Marion <dmarion@iskon.hr>
 *
 */


#ifndef _REX_H_
#define _REX_H_


#define REX_BEEP_ON				0x1C
#define REX_EVENT_MESSAGE_GET			0x2A
#define REX_EVENT_CLEAR				0x30
#define REX_ADDIN_TERMINATE			0x42
#define REX_DISP_LINE				0x50
#define REX_DISP_BLOCK_CLEAR			0x58
#define REX_DISP_WAIT_ICON_DRAW			0x64
#define REX_DIALOG_TEXT_BUTTON			0x7a
#define REX_VERSION_GET				0xA8
#define REX_SYSCALL_EXTENDED			0xCE
#define REX_SOFTWARE_KEYBOARD       		0x0301
#define REX_SLEEP                   		0x0201
#define REX_PRINTF		    		0x0330


#define REX_KEY_HOME 		1
#define REX_KEY_BACK 		2
#define REX_KEY_SELECT 		4
#define REX_KEY_UP 		8
#define REX_KEY_DOWN		16

#define MSG_REX_PAINT		01
#define MSG_REX_CLOSE		02
#define MSG_REX_COMMAND		03
#define MSG_REX_KEY_DOWN	16

extern int __LIB__ SYSCALL0(int);
extern int __LIB__ SYSCALL1(int,...);
extern int __LIB__ SYSCALL4(int,...);
extern int __LIB__ SYSCALL5(int,...);
extern int __LIB__ SYSCALL6(int,...);
extern int __LIB__ SYSCALL6P(int,...);
extern int __LIB__ SYSCALLEX(int,...);


#define RexBeepOn( arg1 )                 		SYSCALL1( REX_BEEP_ON, arg1 )
#define RexEventMessageGet( arg1 )	  		SYSCALL1( REX_EVENT_MESSAGE_GET, arg1 )
#define RexEventClear( )	          		SYSCALL0( REX_EVENT_CLEAR )
#define RexVersionGet( )                 		SYSCALL0(REX_VERSION_GET )
#define RexAddinTerminate( )	          		SYSCALL0( REX_ADDIN_TERMINATE )
#define RexPrintf(arg1, arg2, arg3, arg4, arg5 ) 	SYSCALLEX(REX_PRINTF, arg1, arg2, 0xFFFF, arg3, arg4, arg5)
#define RexSoftwareKeyboard(arg1, arg2)  		SYSCALLEX(REX_SOFTWARE_KEYBOARD, arg1, arg2 )
#define RexSleep( arg1 )                  		SYSCALLEX( REX_SLEEP, arg1 )
#define RexDisplayWaitIconDraw( arg1 )     		SYSCALL1( REX_DISP_WAIT_ICON_DRAW, arg1 )
#define RexDisplayLine( arg1, arg2, arg3, arg4, arg5 ) 	SYSCALL5( REX_DISP_LINE, arg1, arg2, arg3, arg4, arg5 )
#define RexDisplayBlockClear(arg1, arg2, arg3, arg4 )  	SYSCALL4(REX_DISP_BLOCK_CLEAR, arg1, arg2, arg3, arg4 )
#define RexDialogTextButton( arg1, arg2, arg3, arg4, arg5, arg6 ) SYSCALL6P( REX_DIALOG_TEXT_BUTTON, arg1, arg2, arg3, arg4, arg5, arg6 )

#endif /* _REX_H_ */
