;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: sqrt.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;

		INCLUDE		"cpcfirm.def"
		INCLUDE		"cpcfp.def"

		XLIB		sqrt
		XDEF		sqrtc

		LIB		get_para

.sqrt	call	get_para
        call    firmware
.sqrtc	defw	CPCFP_FLO_SQRT
		ret
