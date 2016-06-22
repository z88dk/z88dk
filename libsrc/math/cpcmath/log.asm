;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: log.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

                SECTION         code_fp
		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		log
		PUBLIC		logc

		EXTERN		get_para

.log	call	get_para
        call    firmware
.logc	defw	CPCFP_FLO_LOG
		ret
