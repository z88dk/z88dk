
IF __CPU_INTEL__
INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"
ELIF __CPU_Z80__
INCLUDE "config_private.inc"
ENDIF

SECTION code_driver

PUBLIC ide_soft_reset

IF __IO_CF_8_BIT

EXTERN ide_wait_ready

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.
; by writing to the __IO_CF_IDE_CONTROL register, a software reset
; can be initiated.
;
; this should be followed with a call to "ide_init".
; this is register not available on the standard CF interface.

.ide_soft_reset
;   ld a,00000110b              ;no interrupt, set drives reset
;   out (__IO_CF_IDE_CONTROL),a
;   ld a,00000010b              ;no interrupt, clear drives reset
;   out (__IO_CF_IDE_CONTROL),a

    jp ide_wait_ready           ;carry set on return = operation ok

ELSE

EXTERN ide_wait_ready
EXTERN ide_write_byte, ide_write_byte_preset

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.
; Uses AF, DE
; by writing to the __IO_PIO_IDE_CONTROL register, a software reset
; can be initiated.
;
; this should be followed with a call to "ide_init".

.ide_soft_reset
    ld de,__IO_PIO_IDE_CONTROL<<8|00000110b
    call ide_write_byte         ;no interrupt, set drives reset

    ld de,__IO_PIO_IDE_CONTROL<<8|00000010b
    call ide_write_byte_preset  ;no interrupt, clear drives reset
    jp ide_wait_ready           ;carry set on return = operation ok

ENDIF
