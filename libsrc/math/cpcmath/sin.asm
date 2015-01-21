;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: sin.asm,v 1.3 2015-01-21 10:56:29 stefano Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		sin
		PUBLIC		sinc

		EXTERN		get_para

.sin	call	get_para
        call    firmware
.sinc	defw	CPCFP_FLO_SIN
		ret
