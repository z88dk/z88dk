;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: sin.asm,v 1.1 2003-08-30 16:42:48 dom Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		sin
		XDEF		sinc

		LIB		get_para

.sin		call	get_para
.sinc		call	CPCFP_FLO_SIN
		ret
