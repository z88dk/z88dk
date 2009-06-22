;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: atan.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		XLIB		atan
		XDEF		atanc

		LIB		get_para

.atan		call	get_para

            call    firmware
.atanc		defw	CPCFP_FLO_ATAN
            ret
