divert(-1)

###############################################################
# UART USER CONFIGURATION
# rebuild the library if changes are made
#

# The UART is a serial interface dedicated to communicating
# with the onboard ESP-8266 wifi module.  All the pins of the
# esp module are connected to the fpga, meaning you could use
# the next itself to program new firmware for it, but those
# connections to the fpga are not part of the current fpga config.
# It should be mentioned that the UART can also be disconnected
# from the esp module and, if used in combination with a level
# shifter, it could be used to connect to any serial device.

# The default firmware of the ESP-8266 normally brings the unit
# up in 115200 bps 8N1 mode.  However, older versions of the esp
# module can come up in 57600 bps or 19200 bps mode too.  On
# first connection you should verify that sensible communication
# is established and try different baud rates as necessary.
# Once connection is established you can change speed to 115200 bps.

# The UART can be configured for various baud rates but bytes
# are always framed 8N1 (10 bits per byte transmitted).
# Communication is full duplex, meaning you can transmit and
# receive at the same time.  There is no hardware flow control
# available because of the small number of pins on the esp module.

# The Rx buffer is 256 bytes in size and if it overruns, further
# received bytes will be silently dropped.

# There is no Tx buffer - the moment a byte is sent, it is
# transmitted over the serial link.  Because there is no Tx buffer,
# there must be a time delay between successive bytes sent to
# give time for the currently transmitted byte to leave the UART's
# shift register.  The amount of time needed in z80 clock cycles
# is 10*(Fcpu/R) where Fcpu = cpu speed (3.5Mhz, eg) and R
# is the baud rate (115200, eg).  A status bit can also be
# polled to find out when it's safe to send another byte.

# The UART baud rate is derived from a nominal 28MHz clock.
# However this clock varies depending on the video timing the
# user has selected for his tv.  The actual clock used by the
# UART baud generator can be found by reading nextreg 17 to
# determine the current video timing 0-7 and then using that
# to look up the actual UART clock:

define(`__CLK_28_0', 28000000)
define(`__CLK_28_1', 28571429)
define(`__CLK_28_2', 29464286)
define(`__CLK_28_3', 30000000)
define(`__CLK_28_4', 31000000)
define(`__CLK_28_5', 32000000)
define(`__CLK_28_6', 33000000)
define(`__CLK_28_7', 27000000)

# The UART baud rate is set by writing a 14-bit period measured
# in nominal 28MHz cycles.  Periods for common baud rates are
# shown below:
#
# 28000000 / 2400    = 11666  = 2400 bps
# 28000000 / 4800    = 5833   = 4800 bps
# 28000000 / 9600    = 2916   = 9600 bps
# 28000000 / 19200   = 1458   = 19200 bps
# 28000000 / 31250   = 896    = 31250 bps
# 28000000 / 38400   = 729    = 38400 bps
# 28000000 / 57600   = 486    = 57600 bps
# 28000000 / 115200  = 243    = 115200 bps
#
# The nominal 28MHz clock is fine for calculating periods for
# lower baud rates but as baud rates increase, timing errors
# can cause communication errors.  For faster speeds it is
# best to calculate the baud rate period using the actual
# UART clock as described above.

# These 14-bit baud rate periods are written to the baud rate
# register 7-bits at a time.  In the 8-bit byte written, the top bit
# is set to indicate that the upper 7-bits are being written and
# it is reset to indicate that the lower 7-bits are being written.
#
# Note:  At the moment the lower 7-bits should always be written
# first because this write may also overwrite the top 7-bits.

# PORT 0x143B: UART Rx (read only)
#
# Receive a byte from the Rx buffer.

define(`__IO_UART_RX', 0x143b)

# PORT 0x143B: UART Baud Rate (write only)

define(`__IO_UART_BAUD_RATE', 0x143b)

define(`__IUBR_115200_L', 0x73)
define(`__IUBR_115200_H', 0x81)
define(`__IUBR_57600_L', 0x66)
define(`__IUBR_57600_H', 0x83)
define(`__IUBR_38400_L', 0x59)
define(`__IUBR_38400_H', 0x85)
define(`__IUBR_31250_L', 0x00)
define(`__IUBR_31250_H', 0x87)
define(`__IUBR_19200_L', 0x32)
define(`__IUBR_19200_H', 0x8b)
define(`__IUBR_9600_L', 0x64)
define(`__IUBR_9600_H', 0x96)
define(`__IUBR_4800_L', 0x49)
define(`__IUBR_4800_H', 0xad)
define(`__IUBR_2400_L', 0x12)
define(`__IUBR_2400_H', 0xdb)

define(`__IO_143B_115200_L', __IUBR_115200_L)
define(`__IO_143B_115200_H', __IUBR_115200_H)
define(`__IO_143B_57600_L', __IUBR_57600_L)
define(`__IO_143B_57600_H', __IUBR_57600_H)
define(`__IO_143B_38400_L', __IUBR_38400_L)
define(`__IO_143B_38400_H', __IUBR_38400_H)
define(`__IO_143B_31250_L', __IUBR_31250_L)
define(`__IO_143B_31250_H', __IUBR_31250_H)
define(`__IO_143B_19200_L', __IUBR_19200_L)
define(`__IO_143B_19200_H', __IUBR_19200_H)
define(`__IO_143B_9600_L', __IUBR_9600_L)
define(`__IO_143B_9600_H', __IUBR_9600_H)
define(`__IO_143B_4800_L', __IUBR_4800_L)
define(`__IO_143B_4800_H', __IUBR_4800_H)
define(`__IO_143B_2400_L', __IUBR_2400_L)
define(`__IO_143B_2400_H', __IUBR_2400_H)

# PORT 0x133B: UART Tx (write only)

define(`__IO_UART_TX', 0x133b)

# PORT 0x133B: UART Status (read only)

define(`__IO_UART_STATUS', 0x133b)

define(`__IUS_RX_AVAIL', 0x01)  # active high
define(`__IUS_TX_BUSY', 0x02)   # active high
define(`__IUS_RX_FULL', 0x04)   # active high

define(`__IO_133B_RX_AVAIL', __IUS_RX_AVAIL)
define(`__IO_133B_TX_BUSY', __IUS_TX_READY)
define(`__IO_133B_RX_FULL', __IUS_RX_FULL)

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__CLK_28_0'
PUBLIC `__CLK_28_1'
PUBLIC `__CLK_28_2'
PUBLIC `__CLK_28_3'
PUBLIC `__CLK_28_4'
PUBLIC `__CLK_28_5'
PUBLIC `__CLK_28_6'
PUBLIC `__CLK_28_7'

PUBLIC `__IO_UART_RX'

PUBLIC `__IO_UART_BAUD_RATE'

PUBLIC `__IUBR_115200_L'
PUBLIC `__IUBR_115200_H'
PUBLIC `__IUBR_57600_L'
PUBLIC `__IUBR_57600_H'
PUBLIC `__IUBR_38400_L'
PUBLIC `__IUBR_38400_H'
PUBLIC `__IUBR_31250_L'
PUBLIC `__IUBR_31250_H'
PUBLIC `__IUBR_19200_L'
PUBLIC `__IUBR_19200_H'
PUBLIC `__IUBR_9600_L'
PUBLIC `__IUBR_9600_H'
PUBLIC `__IUBR_4800_L'
PUBLIC `__IUBR_4800_H'
PUBLIC `__IUBR_2400_L'
PUBLIC `__IUBR_2400_H'

PUBLIC `__IO_143B_115200_L'
PUBLIC `__IO_143B_115200_H'
PUBLIC `__IO_143B_57600_L'
PUBLIC `__IO_143B_57600_H'
PUBLIC `__IO_143B_38400_L'
PUBLIC `__IO_143B_38400_H'
PUBLIC `__IO_143B_31250_L'
PUBLIC `__IO_143B_31250_H'
PUBLIC `__IO_143B_19200_L'
PUBLIC `__IO_143B_19200_H'
PUBLIC `__IO_143B_9600_L'
PUBLIC `__IO_143B_9600_H'
PUBLIC `__IO_143B_4800_L'
PUBLIC `__IO_143B_4800_H'
PUBLIC `__IO_143B_2400_L'
PUBLIC `__IO_143B_2400_H'

PUBLIC `__IO_UART_TX'

PUBLIC `__IO_UART_STATUS'

PUBLIC `__IUS_RX_AVAIL'
PUBLIC `__IUS_TX_BUSY'
PUBLIC `__IUS_RX_FULL'

PUBLIC `__IO_133B_RX_AVAIL'
PUBLIC `__IO_133B_TX_BUSY'
PUBLIC `__IO_133B_RX_FULL'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
IFNDEF __ZXN_MAC_UART
DEFINE __ZXN_MAC_UART

defc `__CLK_28_0' = __CLK_28_0
defc `__CLK_28_1' = __CLK_28_1
defc `__CLK_28_2' = __CLK_28_2
defc `__CLK_28_3' = __CLK_28_3
defc `__CLK_28_4' = __CLK_28_4
defc `__CLK_28_5' = __CLK_28_5
defc `__CLK_28_6' = __CLK_28_6
defc `__CLK_28_7' = __CLK_28_7

ENDIF

defc `__IO_UART_RX' = __IO_UART_RX

defc `__IO_UART_BAUD_RATE' = __IO_UART_BAUD_RATE

defc `__IUBR_115200_L' = __IUBR_115200_L
defc `__IUBR_115200_H' = __IUBR_115200_H
defc `__IUBR_57600_L' = __IUBR_57600_L
defc `__IUBR_57600_H' = __IUBR_57600_H
defc `__IUBR_38400_L' = __IUBR_38400_L
defc `__IUBR_38400_H' = __IUBR_38400_H
defc `__IUBR_31250_L' = __IUBR_31250_L
defc `__IUBR_31250_H' = __IUBR_31250_H
defc `__IUBR_19200_L' = __IUBR_19200_L
defc `__IUBR_19200_H' = __IUBR_19200_H
defc `__IUBR_9600_L' = __IUBR_9600_L
defc `__IUBR_9600_H' = __IUBR_9600_H
defc `__IUBR_4800_L' = __IUBR_4800_L
defc `__IUBR_4800_H' = __IUBR_4800_H
defc `__IUBR_2400_L' = __IUBR_2400_L
defc `__IUBR_2400_H' = __IUBR_2400_H

defc `__IO_143B_115200_L' = __IO_143B_115200_L
defc `__IO_143B_115200_H' = __IO_143B_115200_H
defc `__IO_143B_57600_L' = __IO_143B_57600_L
defc `__IO_143B_57600_H' = __IO_143B_57600_H
defc `__IO_143B_38400_L' = __IO_143B_38400_L
defc `__IO_143B_38400_H' = __IO_143B_38400_H
defc `__IO_143B_31250_L' = __IO_143B_31250_L
defc `__IO_143B_31250_H' = __IO_143B_31250_H
defc `__IO_143B_19200_L' = __IO_143B_19200_L
defc `__IO_143B_19200_H' = __IO_143B_19200_H
defc `__IO_143B_9600_L' = __IO_143B_9600_L
defc `__IO_143B_9600_H' = __IO_143B_9600_H
defc `__IO_143B_4800_L' = __IO_143B_4800_L
defc `__IO_143B_4800_H' = __IO_143B_4800_H
defc `__IO_143B_2400_L' = __IO_143B_2400_L
defc `__IO_143B_2400_H' = __IO_143B_2400_H

defc `__IO_UART_TX' = __IO_UART_TX

defc `__IO_UART_STATUS' = __IO_UART_STATUS

defc `__IUS_RX_AVAIL' = __IUS_RX_AVAIL
defc `__IUS_TX_BUSY' = __IUS_TX_BUSY
defc `__IUS_RX_FULL' = __IUS_RX_FULL

defc `__IO_133B_RX_AVAIL' = __IUS_RX_AVAIL
defc `__IO_133B_TX_BUSY' = __IUS_TX_BUSY
defc `__IO_133B_RX_FULL' = __IUS_RX_FULL
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__CLK_28_0'  __CLK_28_0
`#define' `__CLK_28_1'  __CLK_28_1
`#define' `__CLK_28_2'  __CLK_28_2
`#define' `__CLK_28_3'  __CLK_28_3
`#define' `__CLK_28_4'  __CLK_28_4
`#define' `__CLK_28_5'  __CLK_28_5
`#define' `__CLK_28_6'  __CLK_28_6
`#define' `__CLK_28_7'  __CLK_28_7

`#define' `__IO_UART_RX'  __IO_UART_RX

`#define' `__IO_UART_BAUD_RATE'  __IO_UART_BAUD_RATE

`#define' `__IUBR_115200_L'  __IUBR_115200_L
`#define' `__IUBR_115200_H'  __IUBR_115200_H
`#define' `__IUBR_57600_L'  __IUBR_57600_L
`#define' `__IUBR_57600_H'  __IUBR_57600_H
`#define' `__IUBR_38400_L'  __IUBR_38400_L
`#define' `__IUBR_38400_H'  __IUBR_38400_H
`#define' `__IUBR_31250_L'  __IUBR_31250_L
`#define' `__IUBR_31250_H'  __IUBR_31250_H
`#define' `__IUBR_19200_L'  __IUBR_19200_L
`#define' `__IUBR_19200_H'  __IUBR_19200_H
`#define' `__IUBR_9600_L'  __IUBR_9600_L
`#define' `__IUBR_9600_H'  __IUBR_9600_H
`#define' `__IUBR_4800_L'  __IUBR_4800_L
`#define' `__IUBR_4800_H'  __IUBR_4800_H
`#define' `__IUBR_2400_L'  __IUBR_2400_L
`#define' `__IUBR_2400_H'  __IUBR_2400_H

`#define' `__IO_143B_115200_L'  __IO_143B_115200_L
`#define' `__IO_143B_115200_H'  __IO_143B_115200_H
`#define' `__IO_143B_57600_L'  __IO_143B_57600_L
`#define' `__IO_143B_57600_H'  __IO_143B_57600_H
`#define' `__IO_143B_38400_L'  __IO_143B_38400_L
`#define' `__IO_143B_38400_H'  __IO_143B_38400_H
`#define' `__IO_143B_31250_L'  __IO_143B_31250_L
`#define' `__IO_143B_31250_H'  __IO_143B_31250_H
`#define' `__IO_143B_19200_L'  __IO_143B_19200_L
`#define' `__IO_143B_19200_H'  __IO_143B_19200_H
`#define' `__IO_143B_9600_L'  __IO_143B_9600_L
`#define' `__IO_143B_9600_H'  __IO_143B_9600_H
`#define' `__IO_143B_4800_L'  __IO_143B_4800_L
`#define' `__IO_143B_4800_H'  __IO_143B_4800_H
`#define' `__IO_143B_2400_L'  __IO_143B_2400_L
`#define' `__IO_143B_2400_H'  __IO_143B_2400_H

`#define' `__IO_UART_TX'  __IO_UART_TX

`#define' `__IO_UART_STATUS'  __IO_UART_STATUS

`#define' `__IUS_RX_AVAIL'  __IUS_RX_AVAIL
`#define' `__IUS_TX_BUSY'  __IUS_TX_BUSY
`#define' `__IUS_RX_FULL'  __IUS_RX_FULL

`#define' `__IO_133B_RX_AVAIL'  __IUS_RX_AVAIL
`#define' `__IO_133B_TX_BUSY'  __IUS_TX_BUSY
`#define' `__IO_133B_RX_FULL'  __IUS_RX_FULL
')
