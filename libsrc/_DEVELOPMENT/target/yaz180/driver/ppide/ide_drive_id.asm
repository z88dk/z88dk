
SECTION code_driver

PUBLIC ide_drive_id

EXTERN __IO_PIO_IDE_COMMAND

EXTERN __IO_PIO_IDE_HEAD

EXTERN __IDE_CMD_ID

EXTERN ide_wait_ready, ide_wait_drq
EXTERN ide_test_error

EXTERN ide_write_byte
EXTERN ide_read_block

EXTERN ideBuffer

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.

; do the identify drive command, and return with the buffer 
; filled with info about the drive.

; the buffer to fill is in HL

ide_drive_id:
    push af
    push de
    call ide_wait_ready
    jr nc, error
    ld e, 11100000b
    ld a, __IO_PIO_IDE_HEAD
    call ide_write_byte     ;select the master device, LBA mode
    call ide_wait_ready
    jr nc, error
    ld e, __IDE_CMD_ID
    ld a, __IO_PIO_IDE_COMMAND
    call ide_write_byte     ;issue the command
    call ide_wait_ready     ;make sure drive is ready to proceed
    jr nc, error
    call ide_wait_drq       ;wait until it's got the data
    jr nc, error
    call ide_read_block     ;grab the data buffer in (HL++)
    pop de
    pop af
    scf                     ;carry = 1 on return = operation ok
    ret

error:
    pop de
    pop af
    jp ide_test_error       ;carry = 0 on return = operation failed

