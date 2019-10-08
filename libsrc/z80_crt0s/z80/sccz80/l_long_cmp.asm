;
;
;       Small C+ C Compiler
;
;       Long Support Functions
;
;       26/2/99 djm

;
;       I've realised that all the old long comparision functions were
;       (to be polite) fubarred, so I'm endeavouring to rewrite
;       the core so that we get some decent answers out - this is
;       helped no end by having a l_long_sub function which works
;       the right way round!
;
;       Anyway, on with the show; this is the generic compare routine
;       used for all signed long comparisons.

;       Entry: dehl=secondary
;              onstack (under two return addresses) = primary
;
;
;       Exit:     z=number is zero
;              (nz)=number is non-zero 
;                 c=number is negative
;                nc=number is positive


                SECTION   code_crt0_sccz80
                PUBLIC    l_long_cmp


.l_long_cmp
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
; primary - secondary

        bit     7,d
        jr      z,l_long_cmp1
; Negative numbers
        ld      a,h
        or      l
        or      d
        or      e
        ld      hl,1    ; Saves some mem in comparison functions
        scf
        ret

; Number is positive
.l_long_cmp1
        ld      a,h
        or      l
        or      d
        or      e
        scf             ; Could this be replaced by and a?
        ccf
        ld      hl,1    ; Saves some mem in comparision unfunctions
        ret







IF ARCHAIC

.l_long_cmp 
        pop     bc      ;return to calling function
        exx             ;1st
        pop     bc      ;return to program proper
        pop     hl      ;primary number
        pop     de
        push    bc      ;return to program proper
        ld      a,l
        exx
        push    bc
        sub     l
        ld      l,a
        exx
        ld      a,h
        exx             ;1st
        sbc     a,h
        ld      h,a
        exx
        ld      a,e
        exx             ;1st
        sbc     a,e
        ld      e,a
        exx
        ld      a,d
        exx             ;1st
        sbc     a,d
        ld      d,a
;Now, the test
        ld      de,1
        ex      de,hl
        jr      c,l_long_cmp1
        or      e
        ret
.l_long_cmp1
        or      e
        scf     
        ret
ENDIF


