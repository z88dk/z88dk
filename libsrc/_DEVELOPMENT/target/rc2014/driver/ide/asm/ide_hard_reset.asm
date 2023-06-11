
IF __CPU_INTEL__
INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"
ELIF __CPU_Z80__
INCLUDE "config_private.inc"
ENDIF

SECTION code_driver

PUBLIC ide_hard_reset

IF __IO_CF_8_BIT

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.

; do a hard reset on the drive, by pulsing its reset pin.
; this is not available on the standard CF interface.
; this should be followed with a call to "ide_init".

.ide_hard_reset
    scf
    ret

ELSE

EXTERN ide_wait_ready

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.

; do a hard reset on the drive, by pulsing its reset pin.
; do this first, and if a soft reset doesn't work.
; this should be followed with a call to "ide_init".
; uses AF, DE

.ide_hard_reset
    ld a,__IO_PIO_IDE_RD
    out (__IO_PIO_IDE_CONFIG),a ;config 8255 chip, read mode

    ld a,__IO_PIO_IDE_RST_LINE
    out (__IO_PIO_IDE_CTL),a    ;hard reset the disk drive

    xor a                       ;keep iterative count in A
.ide_rst_dly
    dec a
    jp NZ,ide_rst_dly           ;delay 256 nop 150us (reset minimum 25us)

;   xor a
    out (__IO_PIO_IDE_CTL),a    ;no ide control lines asserted

.ide_rst_dly2
    dec a
    jp NZ,ide_rst_dly2          ;delay 256 nop 150us

    jp ide_wait_ready           ;carry set on return = operation ok

ENDIF
