;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: tan.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		XLIB		tan
		XDEF		tanc

		LIB		get_para

.tan	call	get_para
        call    firmware
.tanc	defw	CPCFP_FLO_TAN
		ret
