;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: tan.asm,v 1.1 2008-07-27 21:44:57 aralbrec Exp $
;

		INCLUDE		"#cpcfirm.def"
		INCLUDE		"#cpcfp.def"

		XLIB		tan
		XDEF		tanc

		LIB		get_para

.tan	call	get_para
        call    firmware
.tanc	defw	CPCFP_FLO_TAN
		ret
