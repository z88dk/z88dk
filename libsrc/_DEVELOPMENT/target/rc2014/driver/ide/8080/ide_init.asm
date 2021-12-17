
SECTION code_driver

PUBLIC ide_init

EXTERN __IO_IDE_COMMAND

EXTERN __IO_IDE_HEAD

EXTERN ide_wait_ready
EXTERN ide_test_error

EXTERN ide_write_byte

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.
; Uses AF, DE
; initialize the ide drive

.ide_init
    ld e,11100000b
    ld a,__IO_IDE_HEAD
    call ide_write_byte         ;select the master device, LBA mode
    jp ide_wait_ready           ;carry set on return = operation ok
