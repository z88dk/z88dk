; Internal routine to write double at far pointer
; 31/3/00 GWL

; Entry: E'H'L'=far pointer
;        FA->FA+5=double

;
; $Id: lp_pdoub.asm,v 1.4 2016-06-10 22:42:22 dom Exp $
;

        SECTION   code_clib
        PUBLIC    lp_pdoub
        EXTERN    fa

        EXTERN     farseg1,incfar


.lp_pdoub
        ld      a,($04d1)
	ex	af,af'
        ld      ix,(fa)
        ld      iy,(fa+2)
        ld      hl,(fa+4)
        push    hl
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
        call    incfar
        ld      a,iyh
        ld      (hl),a
        call    incfar
        pop     ix
        ld      a,ixl
        ld      (hl),a
        call    incfar
        ld      a,ixh
        ld      (hl),a
        ex	af,af'
        ld      ($04d1),a
        out     ($d1),a
        ret

