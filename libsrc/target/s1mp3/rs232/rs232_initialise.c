

#include <drivers/rs232.h>
#include <drivers/rtc.h>

port_info_s port_info[RS232_NUMPORTS];

/*unsigned char RS232_Initialise( int port,
			   uint baudRate,
			   uchar stopBits,
			   uchar parityBit,
			   uchar evenParity,
			   uchar nbrofBits)*/
unsigned char RS232_Initialise( void )			
{
#asm

    ; Configure RTC Alarm Timer values
    ld      a, 0xFF
    out     (RTC_ALARM_LO_REG),a
    out     (RTC_ALARM_MI_REG),a
    out     (RTC_ALARM_HI_REG),a

    ; Enable RTC Alarm Timer
    in  a, (RTC_CONTROL_REG)
    or  a, RTC_CONTROL_ALARM_ENABLE
    out (RTC_CONTROL_REG),a
#endasm
}

