
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
; Uses AF, DE
; Carry is set on wait success.

.ide_wait_ready
    ld a,__IO_IDE_ALT_STATUS    ;get IDE alt status register
    call ide_read_byte
    and 00100001b               ;test for ERR or DFE
    ret NZ                      ;return clear carry flag on failure

    ld a,e                      ;get byte from alternate ide_read_byte return
    and 11000000b               ;mask off BuSY and RDY bits
    xor 01000000b               ;wait for RDY to be set and BuSY to be clear
    jp NZ,ide_wait_ready

    scf                         ;set carry flag on success
    ret

