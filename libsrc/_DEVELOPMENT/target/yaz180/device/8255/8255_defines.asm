
EXTERN __IO_PIO_PORT_A, __IO_PIO_PORT_B, __IO_PIO_PORT_C, __IO_PIO_CONTROL
EXTERN __IO_PIO_CNTL_00, __IO_PIO_CNTL_10

PUBLIC __IO_PIO_IDE_LSB, __IO_PIO_IDE_MSB, __IO_PIO_IDE_CTL, __IO_PIO_IDE_CONFIG
PUBLIC __IO_PIO_IDE_RD, __IO_PIO_IDE_WR

PUBLIC __IO_IDE_WR_LINE, __IO_IDE_RD_LINE, __IO_IDE_RST_LINE

PUBLIC __IO_IDE_DATA, __IO_IDE_ERROR, __IO_IDE_SEC_CNT
PUBLIC __IO_IDE_COMMAND, __IO_IDE_STATUS
PUBLIC __IO_IDE_CONTROL, __IO_IDE_ALT_STATUS

PUBLIC __IO_IDE_SECTOR, __IO_IDE_CYL_LSB, __IO_IDE_CYL_MSB, __IO_IDE_HEAD
PUBLIC __IO_IDE_LBA0, __IO_IDE_LBA1, __IO_IDE_LBA2, __IO_IDE_LBA3

;------------------------------------------------------------------------------
; Hardware Configuration

; 8255 PIO chip.  Change these to specify where the PIO is addressed,
; and which of the 8255's ports are connected to which ide signals.
; The first three control which 8255 ports have the control signals,
; upper and lower data bytes.  The last two are mode setting for the
; 8255 to configure its ports, which must correspond to the way that
; the first three lines define which ports are connected.
DEFC    __IO_PIO_IDE_LSB     =   __IO_PIO_PORT_A    ;IDE lower 8 bits
DEFC    __IO_PIO_IDE_MSB     =   __IO_PIO_PORT_B    ;IDE upper 8 bits
DEFC    __IO_PIO_IDE_CTL     =   __IO_PIO_PORT_C    ;IDE control lines
DEFC    __IO_PIO_IDE_CONFIG  =   __IO_PIO_CONTROL   ;PIO configuration
DEFC    __IO_PIO_IDE_RD      =   __IO_PIO_CNTL_10   ;_IO_PIO_IDE_CTL out, _IO_PIO_IDE_LSB/MSB input
DEFC    __IO_PIO_IDE_WR      =   __IO_PIO_CNTL_00   ;all PIO ports output

; IDE control lines for use with __IO_PIO_IDE_CTL. Change these 8
; constants to reflect where each signal of the 8255 each of the
; IDE control signals is connected.  All the control signals must
; be on the same port, but these 8 lines let you connect them to
; whichever pins on that port.
DEFC    __IO_IDE_A0_LINE     =   $10        ;direct from 8255 to ide interface
DEFC    __IO_IDE_A1_LINE     =   $04        ;direct from 8255 to ide interface
DEFC    __IO_IDE_A2_LINE     =   $40        ;direct from 8255 to ide interface
DEFC    __IO_IDE_CS0_LINE    =   $08        ;inverter between 8255 and ide interface
DEFC    __IO_IDE_CS1_LINE    =   $20        ;inverter between 8255 and ide interface
DEFC    __IO_IDE_WR_LINE     =   $01        ;inverter between 8255 and ide interface
DEFC    __IO_IDE_RD_LINE     =   $02        ;inverter between 8255 and ide interface
DEFC    __IO_IDE_RST_LINE    =   $80        ;inverter between 8255 and ide interface

;------------------------------------------------------------------------------
; IDE I/O Register Addressing
;

; IDE control lines for use with __IO_PIO_IDE_CTL. Symbolic constants
; for the IDE registers, which makes the code more readable than
; always specifying the address pins
DEFC    __IO_IDE_DATA        =   __IO_IDE_CS0_LINE
DEFC    __IO_IDE_ERROR       =   __IO_IDE_CS0_LINE + __IO_IDE_A0_LINE
DEFC    __IO_IDE_SEC_CNT     =   __IO_IDE_CS0_LINE + __IO_IDE_A1_LINE                       ;Typically 1 Sector only
DEFC    __IO_IDE_SECTOR      =   __IO_IDE_CS0_LINE + __IO_IDE_A1_LINE + __IO_IDE_A0_LINE    ;LBA0
DEFC    __IO_IDE_CYL_LSB     =   __IO_IDE_CS0_LINE + __IO_IDE_A2_LINE                       ;LBA1
DEFC    __IO_IDE_CYL_MSB     =   __IO_IDE_CS0_LINE + __IO_IDE_A2_LINE + __IO_IDE_A0_LINE    ;LBA2
DEFC    __IO_IDE_HEAD        =   __IO_IDE_CS0_LINE + __IO_IDE_A2_LINE + __IO_IDE_A1_LINE    ;LBA3
DEFC    __IO_IDE_COMMAND     =   __IO_IDE_CS0_LINE + __IO_IDE_A2_LINE + __IO_IDE_A1_LINE + __IO_IDE_A0_LINE
DEFC    __IO_IDE_STATUS      =   __IO_IDE_CS0_LINE + __IO_IDE_A2_LINE + __IO_IDE_A1_LINE + __IO_IDE_A0_LINE

DEFC    __IO_IDE_CONTROL     =   __IO_IDE_CS1_LINE + __IO_IDE_A2_LINE + __IO_IDE_A1_LINE
DEFC    __IO_IDE_ALT_STATUS  =   __IO_IDE_CS1_LINE + __IO_IDE_A2_LINE + __IO_IDE_A1_LINE

DEFC    __IO_IDE_LBA0        =   __IO_IDE_CS0_LINE + __IO_IDE_A1_LINE + __IO_IDE_A0_LINE    ;SECTOR
DEFC    __IO_IDE_LBA1        =   __IO_IDE_CS0_LINE + __IO_IDE_A2_LINE                       ;CYL_LSB
DEFC    __IO_IDE_LBA2        =   __IO_IDE_CS0_LINE + __IO_IDE_A2_LINE + __IO_IDE_A0_LINE    ;CYL_MSB
DEFC    __IO_IDE_LBA3        =   __IO_IDE_CS0_LINE + __IO_IDE_A2_LINE + __IO_IDE_A1_LINE    ;HEAD

