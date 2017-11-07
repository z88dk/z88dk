divert(-1)

###############################################################
# UART USER CONFIGURATION
# rebuild the library if changes are made
#

# The UART is a serial interface dedicated to communicating
# with the onboard ESP-8266 wifi module.  All the pins of the
# esp module are connected to the fpga, meaning you could use
# the next itself to program new firmware for it, but those
# connections to the fpga are not part of the current config.
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

# The Rx buffer is 256 bytes in size but the buffer is circular
# so if it overruns, older unretrieved bytes will be overwritten.
# There is no Tx buffer - the moment a byte is sent, it is
# transmitted over the serial link.  Because there is no Tx buffer,
# there must be a time delay between successive bytes sent to
# give time for the currently transmitted byte to leave the UART's
# shift register.  The amount of time needed in z80 clock cycles
# is 10*(Fcpu/R) where Fcpu = cpu speed (3.5Mhz, eg) and R
# is the baud rate (115200, eg).  A status bit can also be
# polled to find out when it's safe to send another byte.

# PORT 0x143B: UART Rx (read only)
#
# Receive a byte from the Rx buffer.

define(`__IO_UART_RX', 0x143b)

# PORT 0x143B: UART Baud Rate (write only)

define(`__IO_UART_BAUD_RATE', 0x143b)
define(`__IUBR_115200', 0)
define(`__IUBR_57600', 1)
define(`__IUBR_38400', 2)
define(`__IUBR_31250', 3)
define(`__IUBR_19200', 4)
define(`__IUBR_9600', 5)
define(`__IUBR_4800', 6)
define(`__IUBR_2400', 7)

# PORT 0x133B: UART Tx (write only)

define(`__IO_UART_TX', 0x133b)

# PORT 0x133B: UART Status (read only)

define(`__IO_UART_STATUS', 0x133b)
define(`__IUS_RX_AVAIL', 0x01)
define(`__IUS_TX_READY', 0x02)

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__IO_UART_RX'

PUBLIC `__IO_UART_BAUD_RATE'
PUBLIC `__IUBR_115200'
PUBLIC `__IUBR_57600'
PUBLIC `__IUBR_38400'
PUBLIC `__IUBR_31250'
PUBLIC `__IUBR_19200'
PUBLIC `__IUBR_9600'
PUBLIC `__IUBR_4800'
PUBLIC `__IUBR_2400'

PUBLIC `__IO_UART_TX'

PUBLIC `__IO_UART_STATUS'
PUBLIC `__IUS_RX_AVAIL'
PUBLIC `__IUS_TX_READY'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__IO_UART_RX' = __IO_UART_RX

defc `__IO_UART_BAUD_RATE' = __IO_UART_BAUD_RATE
defc `__IUBR_115200' = __IUBR_115200
defc `__IUBR_57600' = __IUBR_57600
defc `__IUBR_38400' = __IUBR_38400
defc `__IUBR_31250' = __IUBR_31250
defc `__IUBR_19200' = __IUBR_19200
defc `__IUBR_9600' = __IUBR_9600
defc `__IUBR_4800' = __IUBR_4800
defc `__IUBR_2400' = __IUBR_2400

defc `__IO_UART_TX' = __IO_UART_TX

defc `__IO_UART_STATUS' = __IO_UART_STATUS
defc `__IUS_RX_AVAIL' = __IUS_RX_AVAIL
defc `__IUS_TX_READY' = __IUS_TX_READY
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__IO_UART_RX'  __IO_UART_RX

`#define' `__IO_UART_BAUD_RATE'  __IO_UART_BAUD_RATE
`#define' `__IUBR_115200'  __IUBR_115200
`#define' `__IUBR_57600'  __IUBR_57600
`#define' `__IUBR_38400'  __IUBR_38400
`#define' `__IUBR_31250'  __IUBR_31250
`#define' `__IUBR_19200'  __IUBR_19200
`#define' `__IUBR_9600'  __IUBR_9600
`#define' `__IUBR_4800'  __IUBR_4800
`#define' `__IUBR_2400'  __IUBR_2400

`#define' `__IO_UART_TX'  __IO_UART_TX

`#define' `__IO_UART_STATUS'  __IO_UART_STATUS
`#define' `__IUS_RX_AVAIL'  __IUS_RX_AVAIL
`#define' `__IUS_TX_READY'  __IUS_TX_READY
')
