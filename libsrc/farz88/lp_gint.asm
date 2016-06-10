; Internal routine to read int at far pointer
; 31/3/00 GWL

; Entry: EHL=far pointer
; Exit: HL=word

;
; $Id: lp_gint.asm,v 1.4 2016-06-10 22:42:22 dom Exp $
;

        SECTION   code_clib
        PUBLIC    lp_gint

        EXTERN     farseg1,incfar


.lp_gint
        ld      a,($04d1)
	ex	af,af'
        ld      b,h
        ld      c,l
        call    farseg1
        ld      a,(hl)
        call    incfar
        ld      h,(hl)
        ld      l,a
        ex	af,af'
        ld      ($04d1),a
        out     ($d1),a
        ret

