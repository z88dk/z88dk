;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: minusfa.asm,v 1.3 2015-01-21 10:56:29 stefano Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		minusfa
		PUBLIC		minusfac

		EXTERN		fa

.minusfa
        ld      hl,fa+1
        call    firmware
.minusfac	
        defw    CPCFP_FLO_INV_SGN	;(hl)=-(hl)
		ret

