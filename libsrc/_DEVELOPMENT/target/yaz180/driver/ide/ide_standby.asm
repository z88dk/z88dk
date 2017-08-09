
SECTION code_driver

PUBLIC ide_standby

EXTERN __IO_IDE_COMMAND

EXTERN __IDE_CMD_STANDBY

EXTERN ide_wait_ready
EXTERN ide_test_error

EXTERN ide_write_byte

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.

; tell the drive to spin down though standby command

ide_standby:
    push af
    push de
    call ide_wait_ready
    jr nc, error
    ld e, __IDE_CMD_STANDBY
    ld a, __IO_IDE_COMMAND
    call ide_write_byte
    call ide_wait_ready
    jr nc, error
    pop de 
    pop af
    scf                     ;carry = 1 on return = operation ok
    ret

error:
    pop de 
    pop af
    jp ide_test_error       ;carry = 0 on return = operation failed

