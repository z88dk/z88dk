
SECTION code_driver

PUBLIC ide_cache_flush

EXTERN __IO_PIO_IDE_COMMAND

EXTERN __IDE_CMD_CACHE_FLUSH

EXTERN ide_wait_ready
EXTERN ide_test_error

EXTERN ide_write_byte

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.

; tell the drive to flush its write cache

ide_cache_flush:
    push af
    push de
    call ide_wait_ready
    jr nc, error
    ld e, __IDE_CMD_CACHE_FLUSH
    ld a, __IO_PIO_IDE_COMMAND
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

