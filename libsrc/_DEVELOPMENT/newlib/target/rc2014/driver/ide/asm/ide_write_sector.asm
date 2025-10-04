
IF __CPU_INTEL__
INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"
ELIF __CPU_Z80__
INCLUDE "config_private.inc"
ENDIF

SECTION code_driver

PUBLIC ide_write_sector

IF __IO_CF_8_BIT

EXTERN ide_wait_ready, ide_wait_drq
EXTERN ide_setup_lba

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.

; write a sector
; specified by the 4 bytes in BCDE
; the address of the origin buffer is in HL
; HL is left incremented by 512 bytes
; uses AF, BC, DE, HL
; return carry on success

.ide_write_sector
    call ide_wait_ready         ;make sure drive is ready
    call ide_setup_lba          ;tell it which sector we want in BCDE

    ld a,1
    out (__IO_CF_IDE_SEC_CNT),a ;set sector count to 1

    ld a,__IDE_CMD_WRITE
    out (__IO_CF_IDE_COMMAND),a ;instruct drive to write a sector

    call ide_wait_ready         ;make sure drive is ready to proceed
    call ide_wait_drq           ;wait until it wants the data

    ;Write a block of 512 bytes (one sector) from (HL++) to
    ;the drive 16 bit data register

IF __CPU_INTEL__
    ld b,0                      ;keep iterative count in b
.ide_wrblk
    ld a,(hl+)
    out (__IO_CF_IDE_DATA),a    ;write the data byte (hl++)
    ld a,(hl+)
    out (__IO_CF_IDE_DATA),a    ;write the data byte (hl++)
    djnz ide_wrblk              ;keep iterative count in b

ELSE
    ld bc,__IO_CF_IDE_DATA&0xFF ;keep iterative count in b, I/O port in c
    otir
    otir

ENDIF

;   call ide_wait_ready
;   ld a,__IDE_CMD_CACHE_FLUSH
;   out (__IO_CF_IDE_COMMAND),a ;tell drive to flush its hardware cache

    jp ide_wait_ready           ;wait until the write is complete

ELSE

EXTERN ide_wait_ready, ide_wait_drq
EXTERN ide_setup_lba

EXTERN ide_write_byte, ide_write_byte_preset
EXTERN ide_write_block

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.

; write a sector
; specified by the 4 bytes in BCDE
; the address of the origin buffer is in HL
; HL is left incremented by 512 bytes
; uses AF, BC, DE, HL
; return carry on success

.ide_write_sector
    push de
    call ide_wait_ready         ;make sure drive is ready

    pop de
    call ide_setup_lba          ;tell it which sector we want in BCDE

    ld de,__IO_PIO_IDE_SEC_CNT<<8|1
    call ide_write_byte_preset  ;set sector count to 1

    ld de,__IO_PIO_IDE_COMMAND<<8|__IDE_CMD_WRITE
    call ide_write_byte_preset  ;instruct drive to write a sector

    call ide_wait_ready         ;make sure drive is ready to proceed
    call ide_wait_drq           ;wait until it wants the data
    call ide_write_block        ;send the data to the drive from (HL++)

;   call ide_wait_ready
;   ld de, __IO_PIO_IDE_COMMAND<<8|__IDE_CMD_CACHE_FLUSH
;   call ide_write_byte         ;tell drive to flush its hardware cache

    jp ide_wait_ready           ;wait until the write is complete

ENDIF
