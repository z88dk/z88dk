/***************************************************************
 *		syscallEx.h
 *			Header for Rex addin program.
 ***************************************************************/
 
#ifndef _SYSTEMCALLEX_
#define _SYSTEMCALLEX_


extern int __LIB__ syscallex(int,...);
extern int __LIB__ syscallexL(int,...);


#define DS_TEXT_OUT_24				0x0001
#define DS_TEXT_WIDTH				0x0002
#define DS_IS_ZENKAKU				0x0003
#define DS_VSCROLL_AREA				0x0005
#define DS_GET_BYTE_BY_PIXEL			0x0006
#define DS_GET_PIXEL_BY_BYTE			0x0007
#define DS_STRCPY				0x0009
#define DS_MEMCPY				0x000A

#define DS_CAL_CURRENT_TIME			0x0101
#define DS_CAL_DATE_TIME			0x0102
#define DS_CAL_TIME_DATE			0x0103
#define DS_CAL_DAY_OF_WEEK_D			0x0104
#define DS_CAL_DAY_OF_WEEK			0x0105
#define DS_CAL_STRFTIME				0x0106
#define DS_CAL_DAY_ADD				0x0107
#define DS_CAL_MONTH_ADD			0x0108
#define DS_CAL_MAX_DAY_OF_MONTH			0x0109
#define DS_CAL_NTH_XDAY_IN_MONTH		0x010A
#define DS_CAL_INT_TO_STR			0x010B
#define DS_CAL_DAY_TO_STR			0x010C
#define DS_CAL_STRFTIME_24			0x010D
#define DS_CAL_DAY_TO_STR_E			0x010E
#define DS_CAL_DATE_TO_STR			0x010F
#define DS_CAL_WEEK_OF_YEAR			0x0110
#define DS_CAL_MINUTE_ADD			0x0111

#define DS_SLEEP				0x0201
#define DS_SYNCHRONIZE				0x0211
#define DS_SETUP_INFO_SET			0x0221
#define DS_PASSWD_ENABLE			0x0222
#define DS_PASSWD_SET				0x0223
#define DS_PASSWD_GET				0x0224
#define DS_USER_INFO_GET			0x0225
#define DS_ALARM_UPDATE				0x0226
#define DS_FLASH_WRITE_START			0x0231
#define DS_FLASH_WRITE_END			0x0232
#define DS_SYSTEM_ERROR_SET			0x0241
#define DS_SYSTEM_ERROR_GET			0x0242
#define DS_SHORTCUT_MASK			0x0250
#define DS_POWER_OFF_COUNT_CLEAR		0x0260

#define DS_SOFTWARE_KEYBOARD			0x0301
#define DS_SOFTWARE_KEYBOARD_SET_INPUT_MODE	0x0302
#define DS_SOFTWARE_KEYBOARD_WITH_YOMI		0x0303
#define DS_DIALOG_WINDOW			0x0311
#define DS_DISPLAY_DAB				0x0321



#define DsTextOut24( arg1, arg2, arg3, arg4, arg5 ) \
						syscallex( DS_TEXT_OUT_24, arg1, arg2, arg3, arg4, arg5 )
						
#define DsTextOut24A( arg1, arg2, arg3, arg4, arg5 ) \
						syscallex( DS_TEXT_OUT_24, arg1, arg2, arg3, arg4, address_24_of(arg5) )
						
#define DsTextWidth( arg1 )			syscallex( DS_TEXT_WIDTH, arg1 )
#define IsZenkaku( arg1 )			syscallex( DS_IS_ZENKAKU, arg1 )

#define DsVScrollArea( arg1, arg2, arg3, arg4, arg5 ) \
						syscallex( DS_VSCROLL_AREA, arg1, arg2, arg3, arg4, arg5 )
						
#define DsGetByteByPixel( arg1, arg2 ) 		syscallex( DS_GET_BYTE_BY_PIXEL, arg1, arg2 )
#define DsGetPixelByByte( arg1, arg2 ) 		syscallex( DS_GET_PIXEL_BY_BYTE, arg1, arg2 )
						
									
#define DsStrCpy( arg1, arg2 )			syscallex( DS_STRCPY, arg1, arg2 )
#define DsStrCpyA( arg1, arg2 )			syscallex( DS_STRCPY, arg1, address_24_of(arg2) )
#define DsMemCpy( arg1, arg2, arg3 ) 		syscallex( DS_MEMCPY, arg1, arg2, arg3 )
#define DsMemCpyA( arg1, arg2, arg3 ) 		syscallex( DS_MEMCPY, arg1, arg2, address_24_of(arg3) )

#define DsCalCurrentTime( arg1, arg2 ) 		syscallex( DS_CAL_CURRENT_TIME, arg1, arg2 )
#define DsCalDateTime( arg1 )			syscallexL( DS_CAL_DATE_TIME, arg1 )
#define DsCalTimeDate( arg1, arg2 )		syscallex( DS_CAL_TIME_DATE, arg1, arg2 )
#define DsCalDayOfWeekD( arg1 )			syscallex( DS_CAL_DAY_OF_WEEK_D, arg1 )
#define DsCalDayOfWeek( arg1 )			syscallex( DS_CAL_DAY_OF_WEEK, arg1 )

#define DsCalStrFTime( arg1, arg2, arg3, arg4, arg5 ) \
						syscallex( DS_CAL_STRFTIME, arg1, arg2, arg3, arg4, arg5 )
									
#define DsCalDayAdd( arg1, arg2 )		syscallex( DS_CAL_DAY_ADD, arg1, arg2 )
#define DsCalMonthAdd( arg1, arg2 )		syscallex( DS_CAL_MONTH_ADD, arg1, arg2 )
#define DsCalMaxDayOfMonth( arg1 )		syscallex( DS_CAL_MAX_DAY_OF_MONTH, arg1 )

#define DsCalNthXdayInMonth( arg1, arg2, arg3, arg4) \
						syscallex( DS_CAL_NTH_XDAY_IN_MONTH, arg1, arg2, arg3, arg4 )
						
#define DsCalIntToStr( arg1, arg2, arg3, arg4 )	syscallex( DS_CAL_INT_TO_STR, arg1, arg2, arg3, arg4 )
#define DsCalDayToStr( arg1, arg2 )		syscallex( DS_CAL_DAY_TO_STR, arg1, arg2 )

#define DsCalStrFTime24( arg1, arg2, arg3, arg4, arg5 ) \
						syscallex( DS_CAL_STRFTIME_24, arg1, arg2, arg3, arg4, arg5 )
						
#define DsCalStrFTime24A( arg1, arg2, arg3, arg4, arg5 ) \
						syscallex( DS_CAL_STRFTIME_24, arg1, arg2, address_24_of(arg3), arg4, arg5 )
						
#define DsCalDayToStrE( arg1, arg2 ) 		syscallex( DS_CAL_DAY_TO_STR_E, arg1, arg2 )
#define DsCalDateToStr( arg1, arg2, arg3 ) 	syscallex( DS_CAL_DATE_TO_STR, arg1, arg2, arg3 )
#define DsCalWeekOfYear( arg1, arg2 ) 		syscallex( DS_CAL_WEEK_OF_YEAR, arg1, arg2 )
#define DsCalMinuteAdd( arg1, arg2, arg3 ) 	syscallex( DS_CAL_MINUTE_ADD, arg1, arg2, arg3 )


#define DsSleep( arg1 )				syscallex( DS_SLEEP, arg1 )
#define DsSynchronize(  )			syscallex( DS_SYNCHRONIZE )
#define DsSetupInfoSet(  )			syscallex( DS_SETUP_INFO_SET )
#define DsPasswdEnable( arg1 )			syscallex( DS_PASSWD_ENABLE, arg1 )
#define DsPasswdSet( arg1 )			syscallex( DS_PASSWD_SET, arg1 )
#define DsPasswdGet( arg1 )			syscallex( DS_PASSWD_GET, arg1 )
#define DsUserInfoGet( arg1, arg2, arg3, arg4 ) syscallex( DS_USER_INFO_GET, arg1, arg2, arg3, arg4 )
#define DsAlarmUpdate(  )			syscallex( DS_ALARM_UPDATE )
#define DsFlashWriteStart(  ) 			syscallex( DS_FLASH_WRITE_START )
#define DsFlashWriteEnd(  ) 			syscallex( DS_FLASH_WRITE_END )
#define DsSystemErrorSet( arg1, arg2, arg3 ) 	syscallex( DS_SYSTEM_ERROR_SET, arg1, arg2, arg3 )
#define DsSystemErrorGet( arg1, arg2 ) 		syscallex( DS_SYSTEM_ERROR_GET, arg1, arg2 )
#define DsShortcutMask( arg1 ) 			syscallex( DS_SHORTCUT_MASK, arg1 )
#define DsPowerOffCountClear()			syscallex( DS_POWER_OFF_COUNT_CLEAR )


#define DsSoftwareKeyboard( arg1, arg2 )	syscallex( DS_SOFTWARE_KEYBOARD, arg1, arg2 )

#define DsSoftwareKeyboardSetInputMode( arg1, arg2, arg3 ) \
						syscallex( DS_SOFTWARE_KEYBOARD_SET_INPUT_MODE, arg1, arg2, arg3 )
						
#define DsSoftwareKeyboardWithYomi( arg1, arg2, arg3 ) \
						syscallex( DS_SOFTWARE_KEYBOARD_WITH_YOMI, arg1, arg2, arg3 )
						
#define DsDialogWindow( arg1, arg2, arg3, arg4 ) \
						syscallex( DS_DIALOG_WINDOW, arg1, arg2, arg3, arg4 )
						
#define DsDisplayTab( arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8 ) \
						syscallex( DS_DISPLAY_DAB, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8 )

#endif /* _SYSTEMCALLEX_ */

