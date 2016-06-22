;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: exp.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

                SECTION         code_fp
		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		PUBLIC		exp
		PUBLIC		expc

		EXTERN		get_para

.exp	call	get_para
        call    firmware
.expc	defw	CPCFP_FLO_EXP
		ret
