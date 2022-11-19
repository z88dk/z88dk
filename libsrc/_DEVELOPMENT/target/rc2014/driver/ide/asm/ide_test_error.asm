
IF __CPU_INTEL__
INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"
ELIF __CPU_Z80__
INCLUDE "config_private.inc"
ENDIF

SECTION code_driver

PUBLIC ide_test_error

IF __IO_CF_8_BIT

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
    and 00000001b               ;test ERR bit
    scf                         ;set carry flag on success
    ret Z                       ;return with carry set

    in a,(__IO_CF_IDE_STATUS)   ;get status byte again
    and 00100000b               ;test write error bit
    ret Z                       ;return carry clear, a = 0, ide write busy timed out

    in a,(__IO_CF_IDE_ERROR)    ;select error register
    or a                        ;make carry flag zero = error!
    ret                         ;if a = 0, ide write busy timed out

ELSE

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
