;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: log.asm,v 1.3 2015-01-21 10:56:29 stefano Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		log
		PUBLIC		logc

		EXTERN		get_para

.log	call	get_para
        call    firmware
.logc	defw	CPCFP_FLO_LOG
		ret
