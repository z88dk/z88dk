;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: atan.asm,v 1.1 2003-08-30 16:42:48 dom Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		atan
		XDEF		atanc

		LIB		get_para

.atan		call	get_para
.atanc		call	CPCFP_FLO_ATAN
		ret
