
SECTION code_driver

PUBLIC ide_read_sector

EXTERN IDE_COMMAND

EXTERN IDE_CMD_READ

EXTERN ide_wait_ready, ide_wait_drq
EXTERN ide_test_error, ide_setup_lba

EXTERN ide_write_byte
EXTERN ide_read_block

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.

; read a sector
; LBA specified by the 4 bytes in BCDE
; the address of the buffer to fill is in HL

; return carry on success, no carry for an error

ide_read_sector:
    push af
    call ide_wait_ready     ;make sure drive is ready
    ret nc
    call ide_setup_lba      ;tell it which sector we want in BCDE
    ld a, IDE_COMMAND
    ld e, IDE_CMD_READ
    call ide_write_byte     ;ask the drive to read it
    call ide_wait_ready     ;make sure drive is ready to proceed
    ret nc
    call ide_test_error     ;ensure no error was reported
    ret nc
    call ide_wait_drq       ;wait until it's got the data
    ret nc
    call ide_read_block     ;grab the data into (HL++)
    pop af
    scf                     ;carry = 1 on return = operation ok
    ret

