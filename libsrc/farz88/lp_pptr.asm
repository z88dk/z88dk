; Internal routine to write pointer at far pointer
; 31/3/00 GWL

; Entry: E'H'L'=far pointer
;        EHL=pointer to write there

;
; $Id: lp_pptr.asm,v 1.4 2016-06-10 22:42:22 dom Exp $
;

        SECTION   code_clib
        PUBLIC    lp_pptr

        EXTERN     farseg1,incfar


.lp_pptr
        ld      a,($04d1)
	ex	af,af'
        push    hl
        pop     ix
        push    de
        pop     iy
        exx
        ld      b,h
        ld      c,l
        call    farseg1
        ld      a,ixl
        ld      (hl),a
        call    incfar
        ld      a,ixh
        ld      (hl),a
        call    incfar
        ld      a,iyl
        ld      (hl),a
	ex	af,af'
        ld      ($04d1),a
        out     ($d1),a
        ret

