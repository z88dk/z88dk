
SECTION code_driver

PUBLIC ide_cache_flush

EXTERN __IO_IDE_COMMAND

EXTERN __IDE_CMD_CACHE_FLUSH

EXTERN ide_wait_ready
EXTERN ide_test_error

EXTERN ide_write_byte

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.
; Uses AF, DE
; tell the drive to flush its write cache

.ide_cache_flush
    call ide_wait_ready
    jp NC,ide_test_error        ;carry = 0 on return = operation failed

    ld e,__IDE_CMD_CACHE_FLUSH
    ld a,__IO_IDE_COMMAND
    call ide_write_byte
    jp ide_wait_ready           ;carry set on return = operation ok

