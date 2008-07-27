;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: sin.asm,v 1.1 2008-07-27 21:44:57 aralbrec Exp $
;

		INCLUDE		"#cpcfirm.def"
		INCLUDE		"#cpcfp.def"

		XLIB		sin
		XDEF		sinc

		LIB		get_para

.sin	call	get_para
        call    firmware
.sinc	defw	CPCFP_FLO_SIN
		ret
