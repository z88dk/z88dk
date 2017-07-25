
SECTION code_driver

PUBLIC ide_spindown

EXTERN IDE_COMMAND

EXTERN IDE_CMD_SPINDOWN

EXTERN ide_wait_ready

EXTERN ide_write_byte

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.

; tell the drive to spin down

ide_spindown:
    push af
    push de
    call ide_wait_ready
    ret nc
    ld e, IDE_CMD_SPINDOWN
    ld a, IDE_COMMAND
    call ide_write_byte
    call ide_wait_ready
    ret nc
    pop de 
    pop af
    ret

