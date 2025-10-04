
IF __CPU_INTEL__
INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"
ELIF __CPU_Z80__
INCLUDE "config_private.inc"
ENDIF

SECTION code_driver

PUBLIC ide_sleep

IF __IO_CF_8_BIT

EXTERN ide_wait_ready

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.
; tell the drive to sleep. only recoverable through hard_reset
; Uses AF
; return carry on success

.ide_sleep
    call ide_wait_ready

    ld a,__IDE_CMD_SLEEP
    out (__IO_CF_IDE_COMMAND),a
    jp ide_wait_ready           ;carry set on return = operation ok

ELSE

EXTERN ide_wait_ready
EXTERN ide_write_byte

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.
; tell the drive to sleep. only recoverable through hard_reset
; Uses AF, DE
; return carry on success

.ide_sleep
    call ide_wait_ready

    ld de,__IO_PIO_IDE_COMMAND<<8|__IDE_CMD_SLEEP
    call ide_write_byte
    jp ide_wait_ready           ;carry set on return = operation ok

ENDIF
