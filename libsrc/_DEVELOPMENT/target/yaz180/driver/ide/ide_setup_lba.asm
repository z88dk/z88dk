
SECTION code_driver

PUBLIC ide_setup_lba

EXTERN IDE_SEC_CNT
EXTERN IDE_LBA0, IDE_LBA1, IDE_LBA2, IDE_LBA3

EXTERN ide_write_byte

EXTERN idestatus

;------------------------------------------------------------------------------
; IDE internal subroutines 
;
; These routines talk to the drive, using the low level I/O.
; Normally a program should not call these directly.
;------------------------------------------------------------------------------

; set up the drive LBA registers
; LBA is contained in BCDE registers
    
ide_setup_lba:
    push af
    push hl
    ld a, IDE_LBA0
    call ide_write_byte     ;set LBA0 0:7
    ld e, d
    ld a, IDE_LBA1
    call ide_write_byte     ;set LBA1 8:15
    ld e, c
    ld a, IDE_LBA2
    call ide_write_byte     ;set LBA2 16:23
    ld a, b
    and 00001111b           ;lowest 4 bits used only
    or  11100000b           ;to enable LBA address mode
    ld hl, idestatus        ;set bit 4 accordingly
    bit 0, (hl)
    jr z, ide_setup_master
    or $10                  ;if it is a slave, set that bit
ide_setup_master:
    ld e, a
    ld a, IDE_LBA3
    call ide_write_byte     ;set LBA3 24:27 + bits 5:7=111
    ld e, $1
    ld a, IDE_SEC_CNT    
    call ide_write_byte     ;set sector count to 1
    pop hl
    pop af
    ret

