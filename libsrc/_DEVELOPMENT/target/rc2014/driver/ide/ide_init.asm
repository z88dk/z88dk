
SECTION code_driver

PUBLIC ide_init

EXTERN __IO_IDE_COMMAND

EXTERN __IO_IDE_HEAD

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
    pop de 
    pop af
    jp ide_wait_ready
