/****************************************************************/
/*		syscall.h
/*			Header for Rex addin program.
/****************************************************************/
#ifndef _SYSTEMCALL_
#define _SYSTEMCALL_

extern int __LIB__ syscall0(int);
extern int __LIB__ syscall1(int,...);
extern int __LIB__ syscall1p(int,...);
extern int __LIB__ syscall2(int,...);
extern int __LIB__ syscall3(int,...);
extern int __LIB__ syscall4(int,...);
extern int __LIB__ syscall4d(int,...);
extern int __LIB__ syscall5(int,...);
extern int __LIB__ syscall5p(int,...);
extern int __LIB__ syscall6(int,...);
extern int __LIB__ syscall6p(int,...);


#define DS_TIME_GET				0x00
#define DS_TIME_SET				0x02
#define DS_LOCAL_TIME_GET			0x04
#define	DS_TIME_24_GET				0x06
#define	DS_TIME_24_SET				0x08
#define	DS_TIME_SUMMER_GET			0x0a
#define DS_TIME_SUMMER_SET			0x0c
#define	DS_MONTH_PERIOD_GET			0x0E
#define	DS_HOME_CITY_GET			0x10
#define	DS_HOME_CITY_SET			0x12
#define	DS_ALARM_TIME_GET			0x14
#define	DS_ALARM_TIME_SET			0x16
#define DS_ALARM_ENABLE				0x18
#define DS_ALARM_SET				0x1A
#define DS_BEEP_ON				0x1C
#define DS_BEEP_SET				0x1E
#define DS_SHELL_REFRESH_TOP			0x20
#define DS_SHELL_PROGRAM_TERM			0x22
#define DS_SHELL_PROGRAM_EXEC			0x24
#define DS_TIME_FORMAT_GET			0x26
#define DS_TIME_FORMAT_SET			0x28
#define DS_EVENT_MESSAGE_GET			0x2A

#define DS_EVENT_ADD				0x2C
#define DS_EVENT_DELETE				0x2E
#define DS_EVENT_CLEAR				0x30
#define DS_EVENT_ENABLE				0x32
#define DS_EVENT_DISABLE			0x34
#define DS_EVENT_STATUS_GET			0x36
#define DS_EVENT_PRIORITY_GET			0x38

#define DS_READ_MESSAGE				0x3a
#define DS_READ_LAST_MESSAGE			0x3c

#define DS_TRAVEL_CITY_SET			0x3e

#define DS_ADDIN_EXECUTE			0x40
#define DS_ADDIN_TERMINATE			0x42

#define DS_TRAVEL_TIME_GET			0x44
#define DS_TRAVEL_TIME_SET			0x46
#define DS_TRAVEL_CITY_GET			0x48

#define DS_DISPLAY_COMPONENT			0x4a
#define DS_SET_SCROLL_SIZE			0x4c
#define DS_DIALOG_SCROLL_THUMB_SET		0x4e
#define DS_DISP_LINE				0x50
#define DS_DISP_POINT_GET			0x52
#define DS_DISP_POINT_SET			0x54
#define DS_DISP_CIRCLE				0x56
#define DS_DISP_BLOCK_CLEAR			0x58
#define DS_DISP_BLOCK_REV			0x5A
#define DS_DISP_BLOCK				0x5C
#define DS_DISP_BLOCK_STORE			0x5E
#define DS_DISP_BLOCK_RESTORE			0x60
#define DS_DISP_IMAGE_OR			0x62
#define DS_DISP_WAIT_ICON_DRAW			0x64
#define DS_TEXT_OUT				0x66
#define DS_DIALOG_EDIT_SHOW			0x68
#define DS_DIALOG_SCROLL_DRAW			0x6A
#define DS_DIALOG_EVENT_SET			0x6C
#define DS_DIALOG_EVENT_DRAW			0x6E
#define DS_DIALOG_CHECK_BOX_SET			0x70
#define DS_DIALOG_CHECK_BOX_DRAW		0x72
#define DS_DISPLAY_BITMAP_DRAW			0x72
#define DS_DIALOG_COMPONENT_DRAW		0x74
#define DS_RESOURCE_CHANGE			0x76
#define DS_ICON_DRAW				0x78
/*#define DS_ICON_MOVE				0x7A*/
#define DS_DIALOG_TEXT_BUTTON			0x7a
#define DS_ICON_REVERSE				0x7C
#define DS_POWER_IDLE_MODE_ENTRY		0x80
#define DS_POWER_STOP_MODE_ENTRY		0x82
#define DS_POWER_MODE_GET			0x84
#define DS_POWER_MODE_SET			0x86
#define DS_POWER_BAT_INFO			0x88
#define DS_POWER_LINE_CHECK			0x8A
#define DS_POWER_OFF_TIME_SET			0x8C
#define DS_POWER_HALT_ENABLE			0x8E
#define DS_KEY_CODE_GET				0x90
#define DS_KEY_REPEAT_SET			0x92
#define DS_KEY_CLICK_SET			0x94
#define DS_FEP_EXECUTE				0x96
#define DS_SOFT_KEY_CLOSE			0x98
#define DS_TOUCH_CALIBRATION			0x9A
#define DS_TOUCH_CLICK_SET			0x9C
#define DS_TOUCH_DATA_GET			0x9E

#define DS_JSTR_CMP				0xA0
#define DS_MALLOC				0xA2
#define DS_REALLOC				0xA4
#define DS_FREE					0xA6

#define DS_VERSION_GET				0xA8
#define DS_ADDIN_PREV_GET			0xaa
#define DS_ADDIN_PREV_SET			0xac

#define DS_SYSCALL_EXTENDED			0xCE

#define DS_DB_INITIALIZE			0xD0
#define DS_DB_CREATE				0xD2
#define DS_DB_OPEN				0xD4
#define DS_DB_CLOSE				0xD6
#define DS_DB_INSERT_RECORD			0xD8
#define DS_DB_DELETE_RECORD			0xDA
#define DS_DB_READ_RECORD			0xDC
#define DS_DB_READ_FIELD			0xDE
#define DS_DB_FIND_RECORD			0xE0
#define DS_DB_NEXT_RECORD			0xE2
#define	DS_DB_PREVIOUS_RECORD			0xE4
#define DS_DB_UPDATE_RECORD			0xE6
#define DS_DB_UPDATE_FIELD			0xE8
#define DS_DB_TEXT_OP				0xEA
#define DS_DB_FLUSH				0xEC
#define DS_DB_GET_RECORD_COUNT			0xEE
#define DS_DB_DESTROY				0xF0
#define DS_DB_SESSION				0xF2
#define DS_DB_COPY_FIELD			0xF4
#define DS_DB_MISC				0xF6



#define DsTimeGet( arg1, arg2 )			syscall2( DS_TIME_GET, arg1, arg2 )
#define DsTimeSet( arg1, arg2 )			syscall2( DS_TIME_SET, arg1, arg2 )
#define DsLocalTimeGet( arg1, arg2, arg3 )	syscall3( DS_LOCAL_TIME_GET, (int)arg1, (int)arg2, arg3 )
#define	DsTime24Get()				syscall0( DS_TIME_24_GET )
#define	DsTime24Set( arg1 )			syscall1( DS_TIME_24_SET, arg1 )
#define DsTimeSummerGet( arg1 )			syscall1( DS_TIME_SUMMER_GET, arg1 )
#define	DsTimeSummerSet( arg1, arg2 ) 		syscall2( DS_TIME_SUMMER_SET, arg1, arg2 )
#define	DsMonthPeriodGet( arg1 )		syscall1( DS_MONTH_PERIOD_GET, arg1 )
#define	DsHomeCityGet()				syscall0( DS_HOME_CITY_GET )
#define	DsHomeCitySet( arg1 )			syscall1( DS_HOME_CITY_SET, arg1 )
#define DsTimeFormatGet()			syscall0( DS_TIME_FORMAT_GET )
#define DsTimeFormatSet( arg1 )			syscall1( DS_TIME_FORMAT_SET, arg1 )
#define DsTravelTimeGet( arg1, arg2 ) 		syscall2( DS_TRAVEL_TIME_GET, arg1, arg2 )
#define DsTravelTimeSet( arg1, arg2 ) 		syscall2( DS_TRAVEL_TIME_SET, arg1, arg2 )
#define DsTravelCityGet()			syscall0( DS_TRAVEL_CITY_GET )
#define DsTravelCitySet( arg1 )			syscall1( DS_TRAVEL_CITY_SET, arg1 )

#define	DsAlarmTimeGet( arg1 ) 			syscall1( DS_ALARM_TIME_GET, arg1 )
#define	DsAlarmTimeSet( arg1 ) 			syscall1( DS_ALARM_TIME_SET, arg1 )

#define DsAlarmEnable( arg1 )			syscall1( DS_ALARM_ENABLE, arg1 )
#define DsAlarmSet( arg1 )			syscall1( DS_ALARM_SET, arg1 )
#define DsBeepOn( arg1 )			syscall1( DS_BEEP_ON, arg1 )
#define DsBeepSet( arg1 )			syscall1( DS_BEEP_SET, arg1 )
#define DsShellRefreshTopMode()			syscall0( DS_SHELL_REFRESH_TOP )
#define DsProgramTerminate( arg1 )		syscall1( DS_SHELL_PROGRAM_TERM, arg1 )
#define DsProgramExecute( arg1 )		syscall1( DS_SHELL_PROGRAM_EXEC, arg1 )
#define DsEventMessageGet( arg1 )		syscall1( DS_EVENT_MESSAGE_GET, arg1 )
#define DsReadMessage( arg1, arg2 )		syscall2( DS_READ_MESSAGE, arg1, arg2 )
#define DsReadLastMessage( arg1 )		syscall1( DS_READ_LAST_MESSAGE, arg1 )

#define DsEventAdd( arg1, arg2, arg3, arg4, arg5, arg6 ) \
					syscall6( DS_EVENT_ADD, arg1, arg2, arg3, arg4, arg5, arg6 )
					
#define DsEventDelete(  )			syscall0( DS_EVENT_DELETE )
#define DsEventClear( ) 			syscall0( DS_EVENT_CLEAR )
#define DsEventEnable( arg1 )			syscall1( DS_EVENT_ENABLE, arg1 )
#define DsEventDisable( arg1 )			syscall1( DS_EVENT_DISABLE, arg1 )
#define DsEventStatusGet( arg1 )		syscall1( DS_EVENT_STATUS_GET, arg1 )
#define DsEventPriorityGet()			syscall0( DS_EVENT_PRIORITY_GET )

#define DsAddinExecute( arg1 )			syscall1( DS_ADDIN_EXECUTE, arg1 )
#define DsAddinTerminate()			syscall0( DS_ADDIN_TERMINATE )



#define DsDisplayComponent( arg1, arg2, arg3 )	syscall3( DS_DISPLAY_COMPONENT, arg1, arg2, arg3 )
#define DsSetScrollSize( arg1 )			syscall1( DS_SET_SCROLL_SIZE, arg1 )
#define DsDialogScrollThumbSet( arg1 )		syscall1( DS_DIALOG_SCROLL_THUMB_SET, arg1 )

#define DsDisplayLine( arg1, arg2, arg3, arg4, arg5 ) \
					syscall5( DS_DISP_LINE, arg1, arg2, arg3, arg4, arg5 )
					
#define DsDisplayPointGet( arg1, arg2 ) 	syscall2( DS_DISP_POINT_GET, arg1, arg2 )
#define DsDisplayPointSet( arg1, arg2, arg3 ) 	syscall3( DS_DISP_POINT_SET, arg1, arg2, arg3 )

#if 0
#define DsDisplayCircle( arg1, arg2, arg3, arg4, arg5 )	syscall5( DS_DISP_CIRCLE, arg1, arg2, arg3, arg4, arg5 )
#endif

#define DsDisplayBlockClear( arg1, arg2, arg3, arg4 ) \
					syscall4( DS_DISP_BLOCK_CLEAR, arg1, arg2, arg3, arg4 )
					
#if 0
#define DsClearScreen() 			syscall4( DS_DISP_BLOCK_CLEAR, 0, 0, 240, 120 )
#endif
					
#define DsDisplayBlockReverse( arg1, arg2, arg3, arg4, arg5 ) \
					syscall5( DS_DISP_BLOCK_REV, arg1, arg2, arg3, arg4, arg5 )
					
#define DsDisplayBlock( arg1, arg2, arg3, arg4, arg5 ) \
					syscall5( DS_DISP_BLOCK, arg1, arg2, arg3, arg4, arg5 )
					
#define DsDisplayBlockStore( arg1, arg2, arg3, arg4, arg5 ) \
					syscall5( DS_DISP_BLOCK_STORE, arg1, arg2, arg3, arg4, arg5 )
					
#define DsDisplayBlockRestore( arg1, arg2 ) 	syscall2( DS_DISP_BLOCK_RESTORE, arg1, arg2 )
#define DsDisplayImageDrawOr()			syscall0( DS_DISP_IMAGE_OR )
#define DsDisplayWaitIconDraw( arg1 ) 		syscall1( DS_DISP_WAIT_ICON_DRAW, arg1 )

#define DsTextOut( arg1, arg2, arg3, arg4, arg5 ) \
					syscall5p( DS_TEXT_OUT, arg1, arg2, arg3, arg4, arg5 )
					
#define DsDisplayBitmapDraw( arg1, arg2, arg3, arg4 ) \
					syscall4d( DS_DISPLAY_BITMAP_DRAW, arg1, arg2, arg3, arg4 )					

#define DsDialogEditShow( arg1 )		syscall1( DS_DIALOG_EDIT_SHOW, arg1 )

#define DsDialogScrollBarDraw( arg1, arg2, arg3, arg4 ) \
					syscall4( DS_DIALOG_SCROLL_DRAW, arg1, arg2, arg3, arg4 )
					
#define DsDialogEventSet( arg1, arg2, arg3, arg4, arg5 ) \
					syscall5( DS_DIALOG_EVENT_SET, arg1, arg2, arg3, arg4, arg5 )
					
#define DsDialogEventDraw( arg1, arg2, arg3, arg4 )	\
					syscall4d( DS_DIALOG_EVENT_DRAW, arg1, arg2, arg3, arg4 )
					
#define DsDialogCheckBoxSet( arg1, arg2, arg3, arg4 ) \
					syscall4( DS_DIALOG_CHECK_BOX_SET, arg1, arg2, arg3, arg4 )
					
#define DsDialogCheckBoxDraw( arg1, arg2, arg3, arg4 ) \
					syscall4( DS_DIALOG_CHECK_BOX_DRAW, arg1, arg2, arg3, arg4 )
					
#define DsDialogComponentDraw( arg1, arg2, arg3, arg4 ) \
					syscall4( DS_DIALOG_COMPONENT_DRAW, arg1, arg2, arg3, arg4 )
					
#define DsResourceGet( arg1 )			syscall1( DS_RESOURCE_GET, arg1 )
#define DsResourceChange( arg1 )		syscall1( DS_RESOURCE_CHANGE, arg1 )
#define DsIconDraw( arg1, arg2, arg3, arg4 ) 	syscall4d( DS_ICON_DRAW, arg1, arg2, arg3, arg4 )
#define DsIconMove( arg1, arg2, arg3, arg4 ) 	syscall4( DS_ICON_MOVE, arg1, arg2, arg3, arg4 )
#define DsIConReverse( arg1 )			syscall1( DS_ICON_REVERSE, arg1 )

#define DsDialogTextButton( arg1, arg2, arg3, arg4, arg5, arg6 ) \
					syscall6p( DS_DIALOG_TEXT_BUTTON, arg1, arg2, arg3, arg4, arg5, arg6 )



#define DsPowerIdleModeEntry()			syscall0( DS_POWER_IDLE_MODE_ENTRY )
#define DsPowerStopModeEntry()			syscall0( DS_POWER_STOP_MODE_ENTRY )
#define DsPowerModeGet()			syscall0( DS_POWER_MODE_GET )
#define DsPowerModeSet()			syscall0( DS_POWER_MODE_SET	)
#define DsPowerBatteryInfoGet()			syscall0( DS_POWER_BAT_INFO	)
#define DsPowerLineCheck()			syscall0( DS_POWER_LINE_CHECK )
#define DsPowerOffTimeSet( arg1 )		syscall1( DS_POWER_OFF_TIME_SET, arg1 )
#define DsPowerHaltEnable()			syscall0( DS_POWER_HALT_ENABLE )



#define DsKeyCodeGet()				syscall0( DS_KEY_CODE_GET )
#define DsKeyRepeatSet( arg1 )			syscall1( DS_KEY_REPEAT_SET, arg1 )
#define DsKeyClickSet( arg1 )			syscall1( DS_KEY_CLICK_SET, arg1 )
#define DsSoftKeyClose()			syscall0( DS_SOFT_KEY_CLOSE	)
#define DsTouchCalibration( arg1 )		syscall1( DS_TOUCH_CALIBRATION, arg1 )
#define DsTouchClickSet( arg1 )			syscall1( DS_TOUCH_CLICK_SET, arg1 )
#define DsTouchDataGet( arg1 )			syscall1p( DS_TOUCH_DATA_GET, arg1 )


#define DsFepExecute()				syscall0( DS_FEP_EXECUTE )


#define DsJStrCmp( arg1, arg2, arg3, arg4, arg5 ) \
					syscall5C( DS_JSTR_CMP, arg1, arg2, arg3, arg4, arg5 )
					
#define DsMalloc( arg1 )			(void *)syscall1( DS_MALLOC, arg1 )
#define DsRealloc( arg1, arg2 )			(void *)syscall2( DS_REALLOC, arg1, arg2 )
#define DsFree( arg1 )				syscall1( DS_FREE, arg1 )


#define DsVersionGet()				syscall0( DS_VERSION_GET )


#define DsAddinPrevGet()			syscall0( DS_ADDIN_PREV_GET )
#define DsAddinPrevSet( arg1 )			syscall1( DS_ADDIN_PREV_SET, arg1 )


#define DsDbInitialize( )			syscall0( DS_DB_INITIALIZE )
#define DsDbCreate( arg1, arg2, arg3 ) 		syscall3( DS_DB_CREATE, arg1, arg2, arg3 )
#define DsDbOpen( arg1 )			syscall1( DS_DB_OPEN, arg1 )
#define DsDbClose( arg1 )			syscall1( DS_DB_CLOSE, arg1 )
#define DsDbInsertRecord( arg1, arg2 ) 		syscall2( DS_DB_INSERT_RECORD, arg1, arg2 )
#define DsDbDeleteRecord( arg1 )		syscall1( DS_DB_DELETE_RECORD, arg1 )
#define DsDbReadRecord( arg1, arg2 ) 		syscall2( DS_DB_READ_RECORD, arg1, arg2 )
#define DsDbReadField( arg1, arg2, arg3 ) 	syscall3( DS_DB_READ_FIELD, arg1, arg2, arg3 )

#define DsDbFindRecord( arg1, arg2, arg3, arg4 ) \
					syscall4( DS_DB_FIND_RECORD, arg1, arg2, arg3, arg4 )
					
#define DsDbNextRecord( arg1 )			syscall1( DS_DB_NEXT_RECORD, arg1 )
#define DsDbPreviousRecord( arg1 )		syscall1( DS_DB_PREVIOUS_RECORD, arg1 )
#define DsDbUpdateRecord( arg1, arg2 ) 		syscall2( DS_DB_UPDATE_RECORD, arg1, arg2 )
#define DsDbUpdateField( arg1, arg2, arg3 ) 	syscall3( DS_DB_UPDATE_FIELD, arg1, arg2, arg3 )
#define DsDbTextOp()				syscall0( DS_DB_TEXT_OP )
#define DsDbFlush()				syscall0( DS_DB_FLUSH )



#endif /* _SYSTEMCALL_ */


