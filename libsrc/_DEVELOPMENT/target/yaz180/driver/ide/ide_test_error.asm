
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

; Carry is set on no error.

ide_test_error:
    push af
    ld a, __IO_IDE_ALT_STATUS    ;select status register
    call ide_read_byte      ;get status in A
    bit 0, a                ;test ERR bit
    jr z, ide_test_success
    bit 5, a
    jr nz, ide_test2        ;test write error bit
    
    ld a, __IO_IDE_ERROR    ;select error register
    call ide_read_byte      ;get error register in a
ide_test2:
    inc sp                  ;pop old af
    inc sp
    or a                    ;make carry flag zero = error!
    ret                     ;if a = 0, ide write busy timed out

ide_test_success:
    pop af
    scf                     ;set carry flag on success
    ret

