;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: log10.asm,v 1.1 2003-08-30 16:42:48 dom Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		log10
		XDEF		log10c

		LIB		get_para

.log10		call	get_para
.log10c		call	CPCFP_FLO_LOG10
		ret
