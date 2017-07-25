
EXTERN PIOA, PIOB, PIOC, PIOCNTL, PIOCNTL00, PIOCNTL10

PUBLIC PIO_IDE_LSB, PIO_IDE_MSB, PIO_IDE_CTL, PIO_IDE_CONFIG
PUBLIC PIO_IDE_RD, PIO_IDE_WR

PUBLIC IDE_WR_LINE, IDE_RD_LINE, IDE_RST_LINE

PUBLIC IDE_DATA, IDE_ERROR, IDE_SEC_CNT
PUBLIC IDE_COMMAND, IDE_STATUS
PUBLIC IDE_CONTROL, IDE_ALT_STATUS

PUBLIC IDE_SECTOR, IDE_CYL_LSB, IDE_CYL_MSB, IDE_HEAD
PUBLIC IDE_LBA0, IDE_LBA1, IDE_LBA2, IDE_LBA3

;------------------------------------------------------------------------------
; Hardware Configuration

; 8255 PIO chip.  Change these to specify where the PIO is addressed,
; and which of the 8255's ports are connected to which ide signals.
; The first three control which 8255 ports have the control signals,
; upper and lower data bytes.  The last two are mode setting for the
; 8255 to configure its ports, which must correspond to the way that
; the first three lines define which ports are connected.
DEFC    PIO_IDE_LSB     =   PIOA        ;IDE lower 8 bits
DEFC    PIO_IDE_MSB     =   PIOB        ;IDE upper 8 bits
DEFC    PIO_IDE_CTL     =   PIOC        ;IDE control lines
DEFC    PIO_IDE_CONFIG  =   PIOCNTL     ;PIO configuration
DEFC    PIO_IDE_RD      =   PIOCNTL10   ;PIO_IDE_CTL out, PIO_IDE_LSB/MSB input
DEFC    PIO_IDE_WR      =   PIOCNTL00   ;all PIO ports output

; IDE control lines for use with PIO_IDE_CTL. Change these 8
; constants to reflect where each signal of the 8255 each of the
; IDE control signals is connected.  All the control signals must
; be on the same port, but these 8 lines let you connect them to
; whichever pins on that port.
DEFC    IDE_A0_LINE     =   $10        ;direct from 8255 to ide interface
DEFC    IDE_A1_LINE     =   $04        ;direct from 8255 to ide interface
DEFC    IDE_A2_LINE     =   $40        ;direct from 8255 to ide interface
DEFC    IDE_CS0_LINE    =   $08        ;inverter between 8255 and ide interface
DEFC    IDE_CS1_LINE    =   $20        ;inverter between 8255 and ide interface
DEFC    IDE_WR_LINE     =   $01        ;inverter between 8255 and ide interface
DEFC    IDE_RD_LINE     =   $02        ;inverter between 8255 and ide interface
DEFC    IDE_RST_LINE    =   $80        ;inverter between 8255 and ide interface

;------------------------------------------------------------------------------
; IDE I/O Register Addressing
;

; IDE control lines for use with PIO_IDE_CTL. Symbolic constants
; for the IDE registers, which makes the code more readable than
; always specifying the address pins
DEFC    IDE_DATA        =   IDE_CS0_LINE
DEFC    IDE_ERROR       =   IDE_CS0_LINE + IDE_A0_LINE
DEFC    IDE_SEC_CNT     =   IDE_CS0_LINE + IDE_A1_LINE  ;Typically 1 Sector only
DEFC    IDE_SECTOR      =   IDE_CS0_LINE + IDE_A1_LINE + IDE_A0_LINE    ;LBA0
DEFC    IDE_CYL_LSB     =   IDE_CS0_LINE + IDE_A2_LINE                  ;LBA1
DEFC    IDE_CYL_MSB     =   IDE_CS0_LINE + IDE_A2_LINE + IDE_A0_LINE    ;LBA2
DEFC    IDE_HEAD        =   IDE_CS0_LINE + IDE_A2_LINE + IDE_A1_LINE    ;LBA3
DEFC    IDE_COMMAND     =   IDE_CS0_LINE + IDE_A2_LINE + IDE_A1_LINE + IDE_A0_LINE
DEFC    IDE_STATUS      =   IDE_CS0_LINE + IDE_A2_LINE + IDE_A1_LINE + IDE_A0_LINE

DEFC    IDE_CONTROL     =   IDE_CS1_LINE + IDE_A2_LINE + IDE_A1_LINE
DEFC    IDE_ALT_STATUS  =   IDE_CS1_LINE + IDE_A2_LINE + IDE_A1_LINE

DEFC    IDE_LBA0        =   IDE_CS0_LINE + IDE_A1_LINE + IDE_A0_LINE    ;SECTOR
DEFC    IDE_LBA1        =   IDE_CS0_LINE + IDE_A2_LINE                  ;CYL_LSB
DEFC    IDE_LBA2        =   IDE_CS0_LINE + IDE_A2_LINE + IDE_A0_LINE    ;CYL_MSB
DEFC    IDE_LBA3        =   IDE_CS0_LINE + IDE_A2_LINE + IDE_A1_LINE    ;HEAD

