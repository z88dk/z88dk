
SECTION code_driver

PUBLIC ide_init

EXTERN __IO_IDE_COMMAND

EXTERN __IO_IDE_HEAD

EXTERN __IDE_CMD_INIT

EXTERN ide_wait_ready

EXTERN ide_write_byte

EXTERN idestatus

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.

; initialize the ide drive

ide_init:
    push af
    push de
    xor a
    ld (idestatus), a   ;set master device
    ld e, 11100000b
    ld a, __IO_IDE_HEAD
    call ide_write_byte ;select the master device, LBA mode
    call ide_wait_ready
    ret nc
    ld e, __IDE_CMD_INIT  ;needed for old drives
    ld a, __IO_IDE_COMMAND
    call ide_write_byte ;do init parameters command
    pop de
    pop af
    jp ide_wait_ready

