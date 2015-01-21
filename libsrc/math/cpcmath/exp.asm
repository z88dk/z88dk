;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: exp.asm,v 1.3 2015-01-21 10:56:29 stefano Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		exp
		PUBLIC		expc

		EXTERN		get_para

.exp	call	get_para
        call    firmware
.expc	defw	CPCFP_FLO_EXP
		ret
