;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: tan.asm,v 1.3 2015-01-21 10:56:29 stefano Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		tan
		PUBLIC		tanc

		EXTERN		get_para

.tan	call	get_para
        call    firmware
.tanc	defw	CPCFP_FLO_TAN
		ret
