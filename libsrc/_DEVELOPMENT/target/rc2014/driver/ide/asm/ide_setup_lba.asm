
IF __CPU_INTEL__
INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"
ELIF __CPU_Z80__
INCLUDE "config_private.inc"
ENDIF

SECTION code_driver

PUBLIC ide_setup_lba

IF __IO_CF_8_BIT

;------------------------------------------------------------------------------
; IDE internal subroutines 
;
; These routines talk to the drive, using the low level I/O.
; Normally a program should not call these directly.
;------------------------------------------------------------------------------

; set up the drive LBA registers
; Uses AF, BC, DE
; LBA is contained in BCDE registers

.ide_setup_lba
    ld a,e
    out (__IO_CF_IDE_LBA0),a    ;set LBA0 0:7
    ld a,d
    out (__IO_CF_IDE_LBA1),a    ;set LBA1 8:15
    ld a,c
    out (__IO_CF_IDE_LBA2),a    ;set LBA2 16:23
    ld a,b
    and 00001111b               ;lowest 4 bits LBA address used only
    or  11100000b               ;to enable LBA address master mode
    out (__IO_CF_IDE_LBA3),a    ;set LBA3 24:27 + bits 5:7=111
    ret

ELSE

EXTERN ide_write_byte
EXTERN ide_write_byte_preset

;------------------------------------------------------------------------------
; IDE internal subroutines 
;
; These routines talk to the drive, using the low level I/O.
; Normally a program should not call these directly.
;------------------------------------------------------------------------------

; set up the drive LBA registers
; Uses AF, BC, DE
; LBA is contained in BCDE registers

.ide_setup_lba
    push de
    ld d,__IO_PIO_IDE_LBA0
    call ide_write_byte         ;set LBA0 0:7
    pop de
    ld e,d
    ld d,__IO_PIO_IDE_LBA1
    call ide_write_byte_preset  ;set LBA1 8:15
    ld e,c
    ld d,__IO_PIO_IDE_LBA2
    call ide_write_byte_preset  ;set LBA2 16:23
    ld a,b
    and 00001111b               ;lowest 4 bits LBA address used only
    or  11100000b               ;to enable LBA address master mode
    ld e,a
    ld d,__IO_PIO_IDE_LBA3
    call ide_write_byte_preset  ;set LBA3 24:27 + bits 5:7=111
    ret

ENDIF
