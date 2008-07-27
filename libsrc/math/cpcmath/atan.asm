;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: atan.asm,v 1.1 2008-07-27 21:44:56 aralbrec Exp $
;

		INCLUDE		"#cpcfirm.def"
		INCLUDE		"#cpcfp.def"

		XLIB		atan
		XDEF		atanc

		LIB		get_para

.atan		call	get_para

            call    firmware
.atanc		defw	CPCFP_FLO_ATAN
            ret
