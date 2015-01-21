;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: atan.asm,v 1.3 2015-01-21 10:56:29 stefano Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		atan
		PUBLIC		atanc

		EXTERN		get_para

.atan		call	get_para

            call    firmware
.atanc		defw	CPCFP_FLO_ATAN
            ret
