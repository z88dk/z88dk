;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: exp.asm,v 1.1 2008-07-27 21:44:56 aralbrec Exp $
;

		INCLUDE		"#cpcfirm.def"
		INCLUDE		"#cpcfp.def"

		XLIB		exp
		XDEF		expc

		LIB		get_para

.exp	call	get_para
        call    firmware
.expc	defw	CPCFP_FLO_EXP
		ret
