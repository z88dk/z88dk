
SECTION code_driver

PUBLIC ide_read_sector

EXTERN __IO_IDE_SEC_CNT, __IO_IDE_COMMAND

EXTERN __IDE_CMD_READ

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
; HL is left incremented by 512 bytes

; return carry on success, no carry for an error

ide_read_sector:
    push af
    push bc
    push de
    call ide_wait_ready     ;make sure drive is ready
    jr nc, error
    call ide_setup_lba      ;tell it which sector we want in BCDE
    ld e, $1
    ld a, __IO_IDE_SEC_CNT    
    call ide_write_byte     ;set sector count to 1
    ld e, __IDE_CMD_READ    
    ld a, __IO_IDE_COMMAND
    call ide_write_byte     ;ask the drive to read it
    call ide_wait_ready     ;make sure drive is ready to proceed
    jr nc, error
    call ide_wait_drq       ;wait until it's got the data
    jr nc, error
    call ide_read_block     ;grab the data into (HL++)
    pop de
    pop bc
    pop af
    scf                     ;carry = 1 on return = operation ok
    ret

error:
    pop de
    pop bc
    pop af
    jp ide_test_error       ;carry = 0 on return = operation failed

