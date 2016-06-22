;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: cos.asm,v 1.4 2016-06-22 19:50:48 dom Exp $
;

                SECTION         code_fp
	        INCLUDE		"cpcfirm.def"

		INCLUDE		"cpcfp.def"

		PUBLIC		cos
		PUBLIC		cosc

		EXTERN		get_para

.cos		call	get_para
            call    firmware
.cosc		defw	CPCFP_FLO_COS
            ret
