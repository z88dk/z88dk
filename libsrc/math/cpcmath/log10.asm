;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: log10.asm,v 1.3 2015-01-21 10:56:29 stefano Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		log10
		PUBLIC		log10c

		EXTERN		get_para

.log10	call	get_para
        call    firmware
.log10c	defw	CPCFP_FLO_LOG10
		ret
