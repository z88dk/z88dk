
SECTION code_driver

PUBLIC ide_write_sector

EXTERN IDE_COMMAND

EXTERN IDE_CMD_WRITE, IDE_CMD_CACHE_FLUSH

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

; return carry on success, no carry for an error

ide_write_sector:
    push af
    call ide_wait_ready     ;make sure drive is ready
    ret nc
    call ide_setup_lba      ;tell it which sector we want in BCDE
    ld a, IDE_COMMAND
    ld e, IDE_CMD_WRITE
    call ide_write_byte     ;instruct drive to write a sector
    call ide_wait_ready     ;make sure drive is ready to proceed
    ret nc
    call ide_test_error     ;ensure no error was reported
    ret nc
    call ide_wait_drq       ;wait until it wants the data
    ret nc
    call ide_write_block    ;send the data to the drive from (HL++)
    call ide_wait_ready
    ret nc
    call ide_test_error     ;ensure no error was reported
    ret nc
    ld a, IDE_COMMAND
    ld e, IDE_CMD_CACHE_FLUSH
    call ide_write_byte     ;tell drive to flush its hardware cache
    call ide_wait_ready     ;wait until the write is complete
    ret nc
    call ide_test_error     ;ensure no error was reported
    ret nc
    pop af
    scf                     ;carry = 1 on return = operation ok
    ret

