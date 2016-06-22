;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: tan.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

                SECTION         code_fp
		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		tan
		PUBLIC		tanc

		EXTERN		get_para

.tan	call	get_para
        call    firmware
.tanc	defw	CPCFP_FLO_TAN
		ret
