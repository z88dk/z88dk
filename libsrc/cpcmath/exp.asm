;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: exp.asm,v 1.1 2003-08-30 16:42:48 dom Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		exp
		XDEF		expc

		LIB		get_para

.exp		call	get_para
.expc		call	CPCFP_FLO_EXP
		ret
