; FREEALL function for far memory model
; 31/3/00 GWL
;
; This function should be called as part of the tidyup
; code for applications or packages using far memory
;
; $Id: freeall_far.asm,v 1.2 2001-04-18 14:59:40 stefano Exp $
;

        XLIB    freeall_far

        XREF    pool_table

include "#memory.def"


; void freeall(void);

.freeall_far
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


