;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: cos.asm,v 1.3 2015-01-21 10:56:29 stefano Exp $
;

        INCLUDE		"cpcfirm.def"

		INCLUDE		"cpcfp.def"

		PUBLIC		cos
		PUBLIC		cosc

		EXTERN		get_para

.cos		call	get_para
            call    firmware
.cosc		defw	CPCFP_FLO_COS
            ret
