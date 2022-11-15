
SECTION code_driver

PUBLIC ide_test_error

IF __IO_CF_8_BIT = 1

EXTERN __IO_CF_IDE_STATUS, __IO_CF_IDE_ERROR

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
    in a,(__IO_CF_IDE_STATUS)
    ld e,a
    and 00000001b               ;test ERR bit
    scf                         ;set carry flag on success
    ret Z                       ;return with carry set

    ld a,e                      ;get status byte
    and 00100000b               ;test write error bit
    ret Z                       ;return carry clear, a = 0, ide write busy timed out

    in a,(__IO_CF_IDE_ERROR)    ;select error register
    or a                        ;make carry flag zero = error!
    ret                         ;if a = 0, ide write busy timed out

ELSE

EXTERN __IO_PIO_IDE_ERROR, __IO_PIO_IDE_ALT_STATUS

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
    ld d,__IO_PIO_IDE_ALT_STATUS;select status register
    call ide_read_byte          ;get status in A
    and 00000001b               ;test ERR bit
    scf                         ;set carry flag on success
    ret Z                       ;return with carry set

    ld a,e                      ;get byte from alternate ide_read_byte return
    and 00100000b               ;test write error bit
    ret Z                       ;return carry clear, a = 0, ide write busy timed out

    ld d,__IO_PIO_IDE_ERROR     ;select error register
    call ide_read_byte          ;get error register in a
    or a                        ;make carry flag zero = error!
    ret                         ;if a = 0, ide write busy timed out

ENDIF
