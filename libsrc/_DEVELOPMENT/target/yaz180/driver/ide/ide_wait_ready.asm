
SECTION code_driver

PUBLIC ide_wait_ready

EXTERN __IO_IDE_ALT_STATUS

EXTERN ide_read_byte

;------------------------------------------------------------------------------
; IDE internal subroutines 
;
; These routines talk to the drive, using the low level I/O.
; Normally a program should not call these directly.
;------------------------------------------------------------------------------

; How to poll (waiting for the drive to be ready to transfer data):
; Read the Regular Status port until bit 7 (BSY, value = 0x80) clears,
; and bit 3 (DRQ, value = 0x08) sets.
; Or until bit 0 (ERR, value = 0x01) or bit 5 (DFE, value = 0x20) sets.
; If neither error bit is set, the device is ready right then.

; Carry is set on wait success.

ide_wait_ready:
    push af
ide_wait_ready2:
    ld a, __IO_IDE_ALT_STATUS    ;get IDE alt status register
    call ide_read_byte
    tst 00100001b           ;test for ERR or DFE
    jr nz, ide_wait_error
    and 11000000b           ;mask off BuSY and RDY bits
    xor 01000000b           ;wait for RDY to be set and BuSY to be clear
    jr nz, ide_wait_ready2
    pop af
    scf                     ;set carry flag on success
    ret

ide_wait_error:
    pop af
    or a                    ;clear carry flag on failure
    ret

