
SECTION code_driver

PUBLIC ide_init

EXTERN __IO_IDE_COMMAND

EXTERN __IO_IDE_HEAD

EXTERN __IDE_CMD_INIT

EXTERN ide_wait_ready
EXTERN ide_test_error

EXTERN ide_write_byte

EXTERN ideStatus

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.

; initialize the ide drive

ide_init:
    push af
    push de
    xor a
    ld (ideStatus), a       ;set master device
    ld e, 11100000b
    ld a, __IO_IDE_HEAD
    call ide_write_byte     ;select the master device, LBA mode
    call ide_wait_ready
    jr nc, error
    ld e, __IDE_CMD_INIT    ;needed for old drives
    ld a, __IO_IDE_COMMAND
    call ide_write_byte     ;do init parameters command
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

