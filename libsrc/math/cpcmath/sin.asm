;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: sin.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

                SECTION         code_fp
		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		sin
		PUBLIC		sinc

		EXTERN		get_para

.sin	call	get_para
        call    firmware
.sinc	defw	CPCFP_FLO_SIN
		ret
