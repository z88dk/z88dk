
SECTION code_driver

PUBLIC ide_wait_drq

EXTERN __IO_PIO_IDE_ALT_STATUS

EXTERN ide_read_byte

;------------------------------------------------------------------------------
; IDE internal subroutines 
;
; These routines talk to the drive, using the low level I/O.
; Normally a program should not call these directly.
;------------------------------------------------------------------------------

; Wait for the drive to be ready to transfer data.
; Returns the drive's status in A

; Carry is set on wait success.

ide_wait_drq:
    push af
ide_wait_drq2:
    ld a, __IO_PIO_IDE_ALT_STATUS    ;get IDE alt status register
    call ide_read_byte
    tst 00100001b           ;test for ERR or WFT
    jr nz, ide_wait_error
    and 10001000b           ;mask off BuSY and DRQ bits
    xor 00001000b           ;wait for DRQ to be set and BuSY to be clear
    jr nz, ide_wait_drq2
    pop af
    scf                     ;set carry flag on success
    ret

ide_wait_error:
    pop af
    or a                    ;clear carry flag on failure
    ret

