;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: sqrt.asm,v 1.1 2003-08-30 16:42:48 dom Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		sqrt
		XDEF		sqrtc

		LIB		get_para

.sqrt		call	get_para
.sqrtc		call	CPCFP_FLO_SQRT
		ret
