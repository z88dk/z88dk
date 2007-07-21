;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: minusfa.asm,v 1.2 2007-07-21 21:28:22 dom Exp $
;

		INCLUDE		"#cpcfirm.def"
		INCLUDE		"#cpcfp.def"

		XLIB		minusfa
		XDEF		minusfac

		XREF		fa

.minusfa
        ld      hl,fa+1
        call    firmware
.minusfac	
        defw    CPCFP_FLO_INV_SGN	;(hl)=-(hl)
		ret

