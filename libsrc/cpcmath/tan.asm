;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: tan.asm,v 1.1 2003-08-30 16:42:48 dom Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		tan
		XDEF		tanc

		LIB		get_para

.tan		call	get_para
.tanc		call	CPCFP_FLO_TAN
		ret
