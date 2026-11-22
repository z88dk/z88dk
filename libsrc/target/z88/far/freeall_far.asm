; FREEALL function for far memory model
; 31/3/00 GWL
;
; This function should be called as part of the tidyup
; code for applications or packages using far memory
;
; $Id: freeall_far.asm,v 1.6 2017-01-02 20:37:10 aralbrec Exp $
;

        SECTION code_clib
        PUBLIC    freeall_far
        PUBLIC    _freeall_far

        EXTERN    pool_table

include "memory.def"


; void freeall(void);

.freeall_far
._freeall_far
        ld      hl,pool_table
        ld      b,224
.freeloop
        ld      a,(hl)
        ld      (hl),0
        inc     hl
        and     a
        call    nz,freepool
        djnz    freeloop
        ret


; Subroutine to free a pool, compressed handle in A

.freepool
        ld      d,0
        add     a,a
        rl      d
        add     a,a
        rl      d
        add     a,a
        rl      d
        add     a,a
        rl      d
        ld      ixh,d
        ld      ixl,a
        call_oz(os_mcl)
        ret


