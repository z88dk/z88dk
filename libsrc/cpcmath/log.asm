;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: log.asm,v 1.2 2007-07-21 21:28:22 dom Exp $
;

		INCLUDE		"#cpcfirm.def"
		INCLUDE		"#cpcfp.def"

		XLIB		log
		XDEF		logc

		LIB		get_para

.log	call	get_para
        call    firmware
.logc	defw	CPCFP_FLO_LOG
		ret
