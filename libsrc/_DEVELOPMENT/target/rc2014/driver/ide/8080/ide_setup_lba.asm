
SECTION code_driver

PUBLIC ide_setup_lba

EXTERN __IO_IDE_LBA0, __IO_IDE_LBA1, __IO_IDE_LBA2, __IO_IDE_LBA3

EXTERN ide_write_byte

EXTERN ideStatus

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
    ld a,__IO_IDE_LBA0
    call ide_write_byte         ;set LBA0 0:7
    pop de
    ld e,d
    ld a,__IO_IDE_LBA1
    call ide_write_byte         ;set LBA1 8:15
    ld e,c
    ld a,__IO_IDE_LBA2
    call ide_write_byte         ;set LBA2 16:23

    ld a,b
    and 00001111b               ;lowest 4 bits LBA address used only
    or  11100000b               ;to enable LBA address master mode
    ld e,a
    ld a,__IO_IDE_LBA3
    call ide_write_byte         ;set LBA3 24:27 + bits 5:7=111
    ret
