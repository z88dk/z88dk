; Internal routine to write char at far pointer
; 31/3/00 GWL

; Entry: E'H'L'=far pointer
;        L=byte

;
; $Id: lp_pchar.asm,v 1.4 2016-06-10 22:42:22 dom Exp $
;

        SECTION   code_clib
        PUBLIC    lp_pchar

        EXTERN     farseg1


.lp_pchar
	ld      a,($04d1)
	ex	af,af'
        exx
        ld      b,h
        ld      c,l
        call    farseg1
        exx
        ld      a,l
        exx
        ld      (hl),a
        ex	af,af'
        ld      ($04d1),a
        out     ($d1),a
        ret

