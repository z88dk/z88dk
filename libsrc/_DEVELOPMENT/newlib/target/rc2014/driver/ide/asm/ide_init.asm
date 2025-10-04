
IF __CPU_INTEL__
INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"
ELIF __CPU_Z80__
INCLUDE "config_private.inc"
ENDIF

SECTION code_driver

PUBLIC ide_init

IF __IO_CF_8_BIT

EXTERN ide_wait_ready

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.
; Uses AF
; initialize the ide drive

.ide_init
    ld a,00000001b              ;select the CF 8-bit interface feature
    out (__IO_CF_IDE_FEATURE),a

    ld a,__IDE_CMD_FEATURE      ;set the feature
    out (__IO_CF_IDE_COMMAND),a

    ld a,11100000b              ;select the master device, LBA mode
    out (__IO_CF_IDE_HEAD),a

    jp ide_wait_ready           ;carry set on return = operation ok

ELSE

EXTERN ide_wait_ready
EXTERN ide_write_byte

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.
; Uses AF, DE
; initialize the ide drive

.ide_init
    ld de,__IO_PIO_IDE_HEAD<<8|11100000b
    call ide_write_byte         ;select the master device, LBA mode
    jp ide_wait_ready           ;carry set on return = operation ok

ENDIF
