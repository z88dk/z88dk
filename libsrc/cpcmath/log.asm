;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: log.asm,v 1.1 2003-08-30 16:42:48 dom Exp $
;

		INCLUDE		"#cpcfp.def"

		XLIB		log
		XDEF		logc

		LIB		get_para

.log		call	get_para
.logc		call	CPCFP_FLO_LOG
		ret
