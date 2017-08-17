
SECTION code_driver

PUBLIC ide_soft_reset

EXTERN __IO_IDE_CONTROL

EXTERN ide_wait_ready
EXTERN ide_test_error

EXTERN ide_write_byte

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.

; by writing to the __IO_IDE_CONTROL register, a software reset
; can be initiated.
; this should be followed with a call to "ide_init".

ide_soft_reset:
    push af
    push de
    ld e, 00000110b         ;no interrupt, set drives reset
    ld a, __IO_IDE_CONTROL
    call ide_write_byte
    ld e, 00000010b         ;no interrupt, clear drives reset
    ld a, __IO_IDE_CONTROL    
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

