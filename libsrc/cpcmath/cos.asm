;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: cos.asm,v 1.1 2003-08-30 16:42:48 dom Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		cos
		XDEF		cosc

		LIB		get_para

.cos		call	get_para
.cosc		call	CPCFP_FLO_COS
		ret
