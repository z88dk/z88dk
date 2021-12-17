
SECTION code_driver

PUBLIC ide_wait_drq

EXTERN __IO_IDE_ALT_STATUS

EXTERN ide_read_byte

;------------------------------------------------------------------------------
; IDE internal subroutines 
;
; These routines talk to the drive, using the low level I/O.
; Normally a program should not call these directly.
;------------------------------------------------------------------------------

; Wait for the drive to be ready to transfer data.
; Returns the drive's status in A
; Uses AF, DE
; Carry is set on wait success.

.ide_wait_drq
    ld a,__IO_IDE_ALT_STATUS    ;get IDE alt status register
    call ide_read_byte
    and 00100001b               ;test for ERR or DFE
    ret NZ                      ;return clear carry flag on failure

    ld a,e                      ;get byte from alternate ide_read_byte return
    and 10001000b               ;mask off BuSY and DRQ bits
    xor 00001000b               ;wait for DRQ to be set and BuSY to be clear
    jp NZ,ide_wait_drq

    scf                         ;set carry flag on success
    ret

