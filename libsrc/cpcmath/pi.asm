;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: pi.asm,v 1.1 2003-08-30 16:42:48 dom Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		pi
		XDEF		pic


		XREF		fa

.pi		ld	hl,fa+1
.pic		call	CPCFP_FLO_PI
		ret
