
SECTION code_driver

PUBLIC ide_spinup

EXTERN IDE_COMMAND

EXTERN IDE_CMD_SPINUP

EXTERN ide_wait_ready

EXTERN ide_write_byte

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.

; tell the drive to spin up

ide_spinup:
    push af
    push de
    call ide_wait_ready
    ret nc
    ld e, IDE_CMD_SPINUP
    ld a, IDE_COMMAND
    call ide_write_byte
    call ide_wait_ready
    ret nc
    pop de 
    pop af
    ret

