;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: deg.asm,v 1.1 2003-08-30 16:42:48 dom Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		deg
		XDEF		degc



.deg		ld	a,1
.degc		call	CPCFP_FLO_DEG_RAD
		ret

