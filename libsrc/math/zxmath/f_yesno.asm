;
;
;       ZX Maths Routines
;
;       23/05/06 - Stefano Bodrato
;
;       $Id: f_yesno.asm,v 1.3 2015-01-19 01:32:57 pauloscustodio Exp $
;


; Support for boolean - save some byte

IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

        PUBLIC    f_yesno


.f_yesno
	call	ZXFP_FP_TO_BC

IF FORzx
        ld	h,b
        ld	l,c
ELSE
        ld	h,c
        ld	l,b
ENDIF

        xor	a
        or	l
        ret	z       ;sets nc

        scf
	ret
