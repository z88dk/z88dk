
SECTION code_driver

PUBLIC ide_write_sector

EXTERN __IO_PIO_IDE_SEC_CNT, __IO_PIO_IDE_COMMAND

EXTERN __IDE_CMD_WRITE, __IDE_CMD_CACHE_FLUSH

EXTERN ide_wait_ready, ide_wait_drq
EXTERN  ide_setup_lba

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

