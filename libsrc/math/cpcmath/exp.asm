;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: exp.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		XLIB		exp
		XDEF		expc

		LIB		get_para

.exp	call	get_para
        call    firmware
.expc	defw	CPCFP_FLO_EXP
		ret
