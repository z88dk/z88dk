; Internal routine to read pointer at far pointer
; 31/3/00 GWL

; Entry: EHL=far pointer
; Exit: EHL=pointer stored there...

;
; $Id: lp_gptr.asm,v 1.4 2016-06-10 22:42:22 dom Exp $
;

        SECTION   code_clib
        PUBLIC    lp_gptr

        EXTERN     farseg1,incfar


.lp_gptr
        ld      a,($04d1)
	ex	af,af'
        ld      b,h
        ld      c,l
        call    farseg1
        ld      a,(hl)
        ld      ixl,a
        call    incfar
        ld      a,(hl)
        ld      ixh,a
        call    incfar
        ld      e,(hl)
	ld	d,0	;padding
        push    ix
        pop     hl
        ex	af,af'
        ld      ($04d1),a
        out     ($d1),a
        ret

