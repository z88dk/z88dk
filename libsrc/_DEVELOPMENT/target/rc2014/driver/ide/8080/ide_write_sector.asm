
SECTION code_driver

PUBLIC ide_write_sector

EXTERN __IO_IDE_SEC_CNT, __IO_IDE_COMMAND

EXTERN __IDE_CMD_WRITE, __IDE_CMD_CACHE_FLUSH

EXTERN ide_wait_ready, ide_wait_drq
EXTERN ide_test_error, ide_setup_lba

EXTERN ide_write_byte
EXTERN ide_write_block

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.

; write a sector
; specified by the 4 bytes in BCDE
; the address of the origin buffer is in HL
; HL is left incremented by 512 bytes
; uses AF, BC, DE, HL
; return carry on success, no carry for an error

.ide_write_sector
    push de
    call ide_wait_ready         ;make sure drive is ready
    pop de
    jp NC,ide_test_error        ;carry = 0 on return = operation failed

    call ide_setup_lba          ;tell it which sector we want in BCDE

    ld e,1
    ld a,__IO_IDE_SEC_CNT
    call ide_write_byte         ;set sector count to 1

    ld e,__IDE_CMD_WRITE
    ld a,__IO_IDE_COMMAND
    call ide_write_byte         ;instruct drive to write a sector
    call ide_wait_ready         ;make sure drive is ready to proceed
    jp NC,ide_test_error        ;carry = 0 on return = operation failed

    call ide_wait_drq           ;wait until it wants the data
    jp NC,ide_test_error        ;carry = 0 on return = operation failed

    call ide_write_block        ;send the data to the drive from (HL++)
    call ide_wait_ready
    jp NC,ide_test_error        ;carry = 0 on return = operation failed

;   ld e, __IDE_CMD_CACHE_FLUSH
;   ld a, __IO_IDE_COMMAND
;   call ide_write_byte         ;tell drive to flush its hardware cache
;   call ide_wait_ready         ;wait until the write is complete
;   jp NC,ide_test_error        ;carry = 0 on return = operation failed

    scf                         ;carry = 1 on return = operation ok
    ret

