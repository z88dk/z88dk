;
;       Z88 Small C+ Run Time Library 
;       Long support functions
;
;       25/2/99 djm
;       Rewritten to use subtraction and use carry at end to figure
;       out which one was larger
;

                SECTION   code_crt0_sccz80
                PUBLIC    l_long_ucmp


; Unsigned compare of dehl (stack) and dehl (registers)
;
; Entry:  primary  = (under two return addresses on stack)
;         secondary= dehl
;
; Exit:           z = numbers the same
;                nz = numbers different
;              c/nc = sign of difference [set if secondary > primary]
;
; Code takes secondary from primary


.l_long_ucmp
        pop     bc      ;return address from this function
                        ;this leaves return address to real program
                        ;and the primary on the stack

; Code cut from l_long_sub here
        exx             ;2nd
        pop     bc
        pop     hl
        pop     de
        push    bc      ;return address to program
        ld      a,l
        exx
        push    bc      ;return address from function
        sub     l
        ld      l,a
        exx             ;1st
        ld      a,h
        exx             ;2nd
        sbc     a,h
        ld      h,a
        exx             ;1st
        ld      a,e
        exx             ;2nd
        sbc     a,e
        ld      e,a     
        exx             ;1st
        ld      a,d
        exx             ;2nd
        sbc     a,d
        ld      d,a

; ATP we have done the comparision and are left with dehl = result of
; primary - secondary, if we have a carry then secondary > primary

        jr      c,l_long_ucmp1  ;

; Primary was larger, return nc
        ld      a,h
        or      l
        or      d
        or      e
        ld      hl,1    ; Saves some mem in comparison functions
        scf             ; Replace with and a?
        ccf
        ret

; Secondary was larger, return nc
.l_long_ucmp1
        ld      a,h
        or      l
        or      d
        or      e
        scf
        ld      hl,1    ; Saves some mem in comparision unfunctions
        ret








IF ARCHAIC
.l_long_ucmp
        ld      a,d
        pop     bc      ;return to calling function
        exx
        pop     bc      ;return to program
        pop     hl      ;value
        pop     de
        push    bc      ;calling program
; pop  exx, push exx    is quicker than pop ix push ox (same length as well)
        exx
        push    bc      ;calling function
        exx             ;1st
        cp      d
        jr      nz,l_long_ucmp1
        exx             ;2nd
        ld      a,e
        exx             ;1st
        cp      e
        jr      nz,l_long_ucmp1
        exx             ;2nd
        ld      a,h
        exx             ;1st
        cp      h
        jr      nz,l_long_ucmp1
        exx             ;2nd
        ld      a,l
        exx             ;1st
        cp      l
.l_long_ucmp1  
        ccf             ;flip carry flag to match other routines
        ld hl,1    ;preset true
        ret

ENDIF
