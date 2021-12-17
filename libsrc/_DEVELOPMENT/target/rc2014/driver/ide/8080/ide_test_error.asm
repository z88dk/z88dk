
SECTION code_driver

PUBLIC ide_test_error

EXTERN __IO_IDE_ERROR, __IO_IDE_ALT_STATUS

EXTERN ide_read_byte

;------------------------------------------------------------------------------
; IDE internal subroutines 
;
; These routines talk to the drive, using the low level I/O.
; Normally a program should not call these directly.
;------------------------------------------------------------------------------

; load the IDE status register and if there is an error noted,
; then load the IDE error register to provide details.
; Uses AF, DE
; Carry is set on no error.

.ide_test_error
    ld a,__IO_IDE_ALT_STATUS    ;select status register
    call ide_read_byte          ;get status in A
    and 00000001b               ;test ERR bit
    scf                         ;set carry flag on success
    ret Z                       ;return with carry set

    ld a,e                      ;get byte from alternate ide_read_byte return
    and 00100000b               ;test write error bit
    ret Z                       ;return carry clear, a = 0, ide write busy timed out

    ld a,__IO_IDE_ERROR         ;select error register
    call ide_read_byte          ;get error register in a
    or a                        ;make carry flag zero = error!
    ret                         ;if a = 0, ide write busy timed out

