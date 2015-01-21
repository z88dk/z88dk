;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: sqrt.asm,v 1.3 2015-01-21 10:56:29 stefano Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		sqrt
		PUBLIC		sqrtc

		EXTERN		get_para

.sqrt	call	get_para
        call    firmware
.sqrtc	defw	CPCFP_FLO_SQRT
		ret
