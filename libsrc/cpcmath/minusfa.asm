;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: minusfa.asm,v 1.1 2003-08-30 16:42:48 dom Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		minusfa
		XDEF		minusfac

		XREF		fa

.minusfa	ld	hl,fa+1
.minusfac	call	CPCFP_FLO_INV_SGN	;(hl)=-(hl)
		ret

